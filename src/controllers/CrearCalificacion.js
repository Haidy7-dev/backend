import { pool } from "../../utils/db.js";

export const CrearCalificacion = async (req, res) => {
  try {
    const { puntaje, id_veterinario_o_zootecnista, id_usuario, id_servicio } =
      req.body;

    if (!puntaje || !id_veterinario_o_zootecnista || !id_usuario || !id_servicio) {
      return res.status(400).json({ message: "Faltan datos obligatorios" });
    }

    const [result] = await pool.query(
      `INSERT INTO calificaciones (puntaje, creado_en, id_veterinario_o_zootecnista, id_usuario, id_servicio)
       VALUES (?, NOW(), ?, ?, ?)`,
      [puntaje, id_veterinario_o_zootecnista, id_usuario, id_servicio]
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