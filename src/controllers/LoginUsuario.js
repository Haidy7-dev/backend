import { pool } from "../../utils/db.js";

export const loginUsuario = async (req, res) => {
  try {
    const { correo_electronico, contrasena } = req.body;

    if (!correo_electronico || !contrasena) {
      return res.status(400).json({ message: "Faltan datos para iniciar sesión." });
    }

    const [rows] = await pool.query(
      "SELECT id, primer_nombre, primer_apellido, correo_electronico FROM usuario WHERE correo_electronico = ? AND contrasena = ?",
      [correo_electronico, contrasena]
    );

    if (rows.length === 0) {
      return res.status(404).json({ message: "Usuario no encontrado o credenciales incorrectas." });
    }

    const user = rows[0];

    return res.status(200).json({
      id: user.id,
      nombre: `${user.primer_nombre} ${user.primer_apellido}`,
      correo: user.correo_electronico,
      tipoUsuario: "usuario",
    });
  } catch (error) {
    console.error("❌ Error al iniciar sesión usuario:", error);
    res.status(500).json({ message: "Error en el servidor." });
  }
};
