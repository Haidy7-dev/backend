import { pool } from "../../utils/db.js";
import bcrypt from "bcrypt";

export const loginUsuario = async (req, res) => {
  try {
    const { correo_electronico, contrasena } = req.body;

    if (!correo_electronico || !contrasena) {
      return res.status(400).json({ message: "Faltan datos para iniciar sesión." });
    }

    // 1. Buscar usuario por correo
    const [rows] = await pool.query(
      "SELECT * FROM usuario WHERE correo_electronico = ?",
      [correo_electronico]
    );

    // 2. Si no se encuentra el usuario, las credenciales son incorrectas
    if (rows.length === 0) {
      return res.status(401).json({ message: "Correo o contraseña incorrectos." });
    }

    const user = rows[0];

    // 3. Comparar la contraseña enviada con el hash de la BD
    const passwordMatches = await bcrypt.compare(contrasena, user.contrasena);

    if (!passwordMatches) {
      return res.status(401).json({ message: "Correo o contraseña incorrectos." });
    }

    // 4. Si todo es correcto, devolver datos del usuario
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
