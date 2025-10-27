import { pool } from "../../utils/db.js";

// --- GET: traer info de la mascota ---
export const obtenerPerfilMascota = async (req, res) => {
  try {
    const { idMascota } = req.params;

    // 🐾 Consulta ajustada al nombre real de tu columna: id_mascota
    const [rows] = await pool.query("SELECT * FROM mascotas WHERE id_mascota = ?", [idMascota]);

    if (rows.length === 0) {
      return res.status(404).json({ message: "No se encontró la mascota" });
    }

    const mascota = rows[0];

    // 🧩 Ajuste de nombres para que coincida con el frontend
    res.json({
      id_mascota: mascota.id_mascota,
      nombre: mascota.nombre,
      peso: mascota.peso,
      sexo: mascota.sexo,
      raza: mascota.raza,
      foto: mascota.foto,
    });
  } catch (error) {
    console.error("❌ Error en obtenerPerfilMascota:", error);
    res.status(500).json({ message: "Error al obtener el perfil de la mascota" });
  }
};

// --- PUT: actualizar info de la mascota ---
export const actualizarPerfilMascota = async (req, res) => {
  try {
    const { idMascota } = req.params;
    const { nombre, peso, sexo, raza, foto } = req.body;

    // 🧩 Actualiza usando la columna id_mascota
    await pool.query(
      "UPDATE mascotas SET nombre = ?, peso = ?, sexo = ?, raza = ?, foto = ? WHERE id_mascota = ?",
      [nombre, peso, sexo, raza, foto, idMascota]
    );

    res.json({ message: "Perfil actualizado correctamente" });
  } catch (error) {
    console.error("❌ Error en actualizarPerfilMascota:", error);
    res.status(500).json({ message: "Error al actualizar el perfil de la mascota" });
  }
};


