import { pool } from "../../utils/db.js";

/**
 * Registrar una nueva mascota
 * POST /api/registroMascota
 */
export const registrarMascota = async (req, res) => {
  try {
    const {
      nombre,
      sexo,
      peso,
      edad,
      especie,
      raza,
      id_usuario, // dueño de la mascota
    } = req.body;

    // Validar campos obligatorios
    if (!nombre || !sexo || !peso || !edad || !especie || !raza || !id_usuario) {
      return res.status(400).json({
        message: "Faltan campos obligatorios para registrar la mascota.",
      });
    }

    // Guardar en la base de datos
    const [result] = await pool.query(
      `INSERT INTO mascota (nombre, sexo, peso, edad, especie, raza, id_usuario)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [nombre, sexo, peso, edad, especie, raza, id_usuario]
    );

    console.log("✅ Mascota registrada con ID:", result.insertId);

    res.status(201).json({
      message: "Mascota registrada correctamente.",
      id_mascota: result.insertId,
    });
  } catch (error) {
    console.error("❌ Error al registrar mascota:", error);
    res.status(500).json({ message: "Error interno del servidor." });
  }
};

/**
 * Obtener todas las mascotas de un usuario
 * GET /api/registroMascota/:id_usuario
 */
export const obtenerMascotasPorUsuario = async (req, res) => {
  try {
    const { id_usuario } = req.params;

    const [mascotas] = await pool.query(
      "SELECT * FROM mascota WHERE id_usuario = ?",
      [id_usuario]
    );

    res.json(mascotas);
  } catch (error) {
    console.error("❌ Error al obtener mascotas:", error);
    res.status(500).json({ message: "Error al obtener las mascotas." });
  }
};