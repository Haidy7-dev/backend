import { pool } from "../../utils/db.js";

export const getResumenCita = async (req, res) => {
  const { idCita } = req.params;

  try {
    const [rows] = await pool.query(
      `
      SELECT
          r.id AS id_resumen,
          r.modalidad,
          r.hora_inicio,
          r.hora_finalizacion,
          r.iva,
          r.total,
          r.id_cita,

          -- 🐶 Datos de la mascota
          m.nombre AS nombre_mascota,
          m.sexo AS sexo_mascota,
          m.foto AS fotoMascota,

          -- Calificación
          CASE WHEN cal.id IS NOT NULL THEN 1 ELSE 0 END AS calificada,

          -- 💼 Datos del servicio
          s.nombre AS nombre_servicio,
          s.precio AS precio_servicio,

          -- 👤 Datos del usuario (cliente)
          CONCAT(u.primer_nombre, ' ', u.primer_apellido) AS nombre_usuario,
          u.correo_electronico AS correo_usuario,

          -- 👨‍⚕️ Datos del veterinario o zootecnista
          CONCAT(v.primer_nombre, ' ', v.primer_apellido) AS nombre_veterinario,
          v.correo_electronico AS correo_veterinario,

          -- 📍 Lugar de la cita
          CASE
              WHEN r.modalidad = 'En casa' THEN u.direccion
              ELSE v.direccion_clinica
          END AS lugar

      FROM resumen_citas r
      LEFT JOIN citas c ON r.id_cita = c.id
      LEFT JOIN mascota m ON c.id_mascota = m.id
      LEFT JOIN servicio s ON c.id_servicio = s.id
      LEFT JOIN usuario u ON c.id_usuario = u.id
      LEFT JOIN veterinario_o_zootecnista v ON c.id_veterinario_o_zootecnista = v.id
      LEFT JOIN calificaciones cal ON cal.id_usuario = c.id_usuario AND cal.id_veterinario_o_zootecnista = c.id_veterinario_o_zootecnista AND cal.id_servicio = c.id_servicio
      WHERE r.id_cita = ?
      `,
      [idCita]
    );

    if (rows.length === 0) {
      return res.status(404).json({ message: "Resumen de cita no encontrado" });
    }

    res.json(rows[0]);
  } catch (error) {
    console.error("❌ Error en getResumenCita:", error);
    res.status(500).json({ message: "Error interno del servidor" });
  }
};

