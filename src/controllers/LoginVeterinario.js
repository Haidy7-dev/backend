import { pool } from "../../utils/db.js";

// 🔹 Controlador para inicio de sesión de veterinario o zootecnista
export const loginVeterinario = async (req, res) => {
  try {
    const { correo_electronico, contrasena } = req.body;

    if (!correo_electronico || !contrasena) {
      return res
        .status(400)
        .json({ message: "Faltan datos para iniciar sesión." });
    }

    // 🔹 Verificar si existe el veterinario o zootecnista
    const [rows] = await pool.query(
      "SELECT * FROM veterinario_o_zootecnista WHERE correo_electronico = ? AND contrasena = ?",
      [correo_electronico, contrasena]
    );

    if (rows.length === 0) {
      return res
        .status(404)
        .json({ message: "Veterinario no encontrado o credenciales incorrectas." });
    }

    // 🔹 Respuesta exitosa
    res.status(200).json({
      message: "Inicio de sesión exitoso",
      id: rows[0].id,
      nombre: `${rows[0].primer_nombre} ${rows[0].primer_apellido}`,
      correo: rows[0].correo_electronico,
    });

  } catch (error) {
    console.error("❌ Error en loginVeterinario:", error);
    res.status(500).json({ message: "Error interno del servidor." });
  }
};


