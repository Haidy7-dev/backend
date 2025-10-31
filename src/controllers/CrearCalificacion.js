import { pool } from "../../utils/db.js";

export const CrearCalificacion = async (req, res) => {
  try {
    const { puntaje, id_cita, id_usuario } = req.body;

    if (!puntaje || !id_cita || !id_usuario) {
      return res.status(400).json({ message: "Faltan datos obligatorios" });
    }

    // Obtener id_veterinario_o_zootecnista y id_servicio desde la cita
    const [citaRows] = await pool.query(
      `SELECT id_veterinario_o_zootecnista, id_servicio FROM citas WHERE id = ?`,
      [id_cita]
    );

    if (citaRows.length === 0) {
      return res.status(404).json({ message: "Cita no encontrada" });
    }

    const { id_veterinario_o_zootecnista, id_servicio } = citaRows[0];

    // Insertar la calificación
    const [result] = await pool.query(
      `INSERT INTO calificaciones (puntaje, creado_en, id_veterinario_o_zootecnista, id_usuario, id_servicio)
       VALUES (?, NOW(), ?, ?, ?)`,
      [puntaje, id_veterinario_o_zootecnista, id_usuario, id_servicio]
    );

    // Calcular el nuevo promedio de calificaciones para el veterinario
    const [avgRows] = await pool.query(
      `SELECT ROUND(AVG(puntaje), 1) AS promedio FROM calificaciones WHERE id_veterinario_o_zootecnista = ?`,
      [id_veterinario_o_zootecnista]
    );

    const nuevoPromedio = avgRows[0].promedio || 0;

    // Actualizar el promedio en la tabla veterinario_o_zootecnista
    await pool.query(
      `UPDATE veterinario_o_zootecnista SET promedio_calificaciones = ? WHERE id = ?`,
      [nuevoPromedio, id_veterinario_o_zootecnista]
    );

    res.status(201).json({
      message: "✅ Calificación registrada correctamente",
      id: result.insertId,
    });
  } catch (error) {
    console.error("❌ Error al crear calificación:", error);
    res.status(500).json({ message: "Error al registrar la calificación" });
  }
};
