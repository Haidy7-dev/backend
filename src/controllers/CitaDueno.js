import { pool } from "../../utils/db.js";

export const getCitasBasicasDueno = async (req, res) => {
  try {
    const { idDueno } = req.params;

    const [rows] = await pool.query(`
      SELECT
        c.id,
        c.fecha,
        c.hora_inicio,
        c.hora_finalizacion,
        c.id_estado_cita,
        c.id_veterinario_o_zootecnista,
        c.id_servicio,
        m.nombre AS nombre_mascota,
        s.nombre AS nombre_servicio,
        v.primer_nombre AS nombre_veterinario_o_zootecnista,
        m.foto,
        CASE WHEN cal.id IS NOT NULL THEN 1 ELSE 0 END AS calificada
      FROM citas c
      INNER JOIN mascota m ON c.id_mascota = m.id
      INNER JOIN servicio s ON c.id_servicio = s.id
      INNER JOIN veterinario_o_zootecnista v ON c.id_veterinario_o_zootecnista = v.id
      LEFT JOIN calificaciones cal ON cal.id_veterinario_o_zootecnista = v.id AND cal.id_usuario = c.id_usuario AND cal.id_servicio = s.id
      WHERE c.id_usuario = ?
      ORDER BY c.fecha DESC
    `, [idDueno]);

    res.json(rows);
  } catch (error) {
    console.error("❌ Error al obtener citas del dueño:", error);
    res.status(500).json({ error: "Error al obtener citas" });
  }
};

// 🔹 Actualizar estado de una cita (culminada, cancelada, etc.)
export const actualizarEstadoCitaDueno = async (req, res) => {
  try {
    const { id } = req.params;
    const { estado } = req.body;

    if (!estado) {
      return res.status(400).json({ error: "El estado es requerido." });
    }

    const [result] = await pool.query("UPDATE citas SET id_estado_cita = ? WHERE id = ?", [estado, id]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: "Cita no encontrada." });
    }

    // Si la cita se marca como completada (estado 2), crear el resumen si no existe
    if (estado == 2) {
      // Verificar si ya existe un resumen para esta cita
      const [existingResumen] = await pool.query("SELECT id FROM resumen_citas WHERE id_cita = ?", [id]);

      if (existingResumen.length === 0) {
        // Obtener datos de la cita para calcular el resumen
        const [citaRows] = await pool.query(`
          SELECT
              c.hora_inicio,
              c.hora_finalizacion,
              s.precio,
              s.modalidad,
              u.direccion
          FROM citas c
          JOIN servicio s ON c.id_servicio = s.id
          JOIN usuario u ON c.id_usuario = u.id
          WHERE c.id = ?
        `, [id]);

        if (citaRows.length > 0) {
          const { hora_inicio, hora_finalizacion, precio, modalidad, direccion } = citaRows[0];
          const precioNum = parseFloat(precio);
          const iva = 19; // IVA del 19%
          const total = precioNum * (1 + iva / 100);

          // Insertar en resumen_citas
          await pool.query(`
            INSERT INTO resumen_citas (modalidad, hora_inicio, hora_finalizacion, iva, total, id_cita)
            VALUES (?, ?, ?, ?, ?, ?)
          `, [modalidad, hora_inicio, hora_finalizacion, iva, total, id]);
        }
      }
    }

    res.json({ message: "✅ Estado actualizado correctamente" });
  } catch (error) {
    console.error("❌ Error al actualizar estado de la cita:", error);
    res.status(500).json({ error: "Error al actualizar estado", message: error.message });
  }
};
