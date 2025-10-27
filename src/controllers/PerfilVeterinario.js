import { pool } from "../db.js";

// ✅ Obtener veterinario por ID
export const getVeterinarioPorId = async (req, res) => {
  try {
    const { id } = req.params;
    const [rows] = await pool.query("SELECT * FROM veterinario WHERE id = ?", [id]);

    if (rows.length === 0) {
      return res.status(404).json({ message: "Veterinario no encontrado" });
    }

    res.json(rows[0]);
  } catch (error) {
    console.error("❌ Error al obtener veterinario:", error);
    res.status(500).json({ message: "Error del servidor" });
  }
};

// ✅ Actualizar datos del veterinario
export const actualizarVeterinario = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      nombre,
      identificacion,
      correo_electronico,
      telefono,
      especializacion,
      informacion,
      foto,
    } = req.body;

    await pool.query(
      `UPDATE veterinario 
       SET nombre=?, identificacion=?, correo_electronico=?, telefono=?, 
           especializacion=?, informacion=?, foto=? 
       WHERE id=?`,
      [
        nombre,
        identificacion,
        correo_electronico,
        telefono,
        especializacion,
        informacion,
        foto,
        id,
      ]
    );

    res.json({ message: "✅ Veterinario actualizado correctamente" });
  } catch (error) {
    console.error("❌ Error al actualizar veterinario:", error);
    res.status(500).json({ message: "Error del servidor" });
  }
};
