import { pool } from "../../utils/db.js";

export const loginUsuario = async (req, res) => {
  const { correo_electronico, contrasena } = req.body;

  try {
    const [rows] = await pool.query(
      "SELECT * FROM usuario WHERE correo_electronico = ? AND contrasena = ?",
      [correo_electronico, contrasena]
    );

    if (rows.length > 0) {
      res.json(rows[0]);
    } else {
      res.status(404).json({ message: "Usuario no encontrado" });
    }
  } catch (error) {
    console.error("Error al iniciar sesión usuario:", error);
    res.status(500).json({ message: "Error en el servidor" });
  }
};

