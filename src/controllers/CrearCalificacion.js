import { pool } from "../../utils/db.js";

export const CrearCalificacion = async (req, res) => {
  try {
    const { puntaje, id_cita, id_usuario, id_veterinario_o_zootecnista, id_servicio } = req.body;

    if (!puntaje || !id_cita || !id_usuario || !id_veterinario_o_zootecnista || !id_servicio) {
      return res.status(400).json({ message: "Faltan datos obligatorios para la calificación" });
    }

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
