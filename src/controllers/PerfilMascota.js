import { pool } from "../../utils/db.js";

// --- GET: traer info de la mascota ---
export const getMascotaPorId = async (req, res) => {
  try {
    const { id } = req.params;

    // Consulta ajustada al nombre real de tu columna: id
    const [rows] = await pool.query("SELECT * FROM mascota WHERE id = ?", [id]);

    if (rows.length === 0) {
      return res.status(404).json({ message: "No se encontró la mascota" });
    }

    const mascota = rows[0];

    res.json({
      id_mascota: mascota.id,
      nombre: mascota.nombre,
      peso: mascota.peso,
      sexo: mascota.sexo,
      id_raza: mascota.id_raza,
      id_especie: mascota.id_especie,
    });
  } catch (error) {
    console.error("❌ Error en getMascota:", error);
    res.status(500).json({ message: "Error al obtener el perfil de la mascota" });
  }
};

// --- PUT: actualizar info de la mascota ---
export const actualizarPerfilMascota = async (req, res) => {
  try {
    const { id } = req.params;
    const { nombre, peso, sexo, id_raza, id_especie } = req.body;

    await pool.query(
      "UPDATE mascota SET nombre = ?, peso = ?, sexo = ?, id_raza = ?, id_especie = ? WHERE id = ?",
      [nombre, peso, sexo, id_raza, id_especie, id]
    );

    res.json({ message: "Perfil actualizado correctamente" });
  } catch (error) {
    console.error("❌ Error en actualizarPerfilMascota:", error);
    res.status(500).json({ message: "Error al actualizar el perfil de la mascota" });
  }
};




