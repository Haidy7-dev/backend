import { pool } from "../../utils/db.js";

export const registrarMascota = async (req, res) => {
  try {
    const {
      nombre,
      sexo,
      peso,
      edad,
      id_usuario,
      id_raza,
      id_especie,
      foto = "foto1.png",
    } = req.body;

    if (!nombre || !sexo || !peso || !edad || !id_usuario || !id_raza || !id_especie) {
      return res.status(400).json({
        message: "Faltan campos obligatorios para registrar la mascota.",
      });
    }

    const [result] = await pool.query(
      `INSERT INTO mascota (nombre, sexo, peso, edad, id_usuario, id_raza, id_especie, foto)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [nombre, sexo, peso, edad, id_usuario, id_raza, id_especie, foto]
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

export const obtenerMascotaPorId = async (req, res) => {
  try {
    const { id } = req.params;
    const [rows] = await pool.query("SELECT * FROM mascota WHERE id = ?", [id]);

    if (rows.length <= 0) {
      return res.status(404).json({ message: "Mascota no encontrada" });
    }

    res.json(rows[0]);
  } catch (error) {
    console.error("❌ Error al obtener mascota por ID:", error);
    res.status(500).json({ message: "Error interno del servidor" });
  }
};
