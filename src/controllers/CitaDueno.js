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
        m.nombre AS nombre_mascota,
        s.nombre AS nombre_servicio,
        v.primer_nombre AS nombre_veterinario_o_zootecnista,
        m.foto
      FROM citas c
      INNER JOIN mascota m ON c.id_mascota = m.id
      INNER JOIN servicio s ON c.id_servicio = s.id
      INNER JOIN veterinario_o_zootecnista v ON c.id_veterinario_o_zootecnista = v.id
      WHERE m.id_usuario = ?
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

    await pool.query("UPDATE citas SET estado = ? WHERE id_cita = ?", [estado, id]);
    res.json({ message: "✅ Estado actualizado correctamente" });
  } catch (error) {
    console.error("❌ Error al actualizar estado de la cita:", error);
    res.status(500).json({ error: "Error al actualizar estado" });
  }
};