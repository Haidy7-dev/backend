import { pool } from "../../utils/db.js";
import bcrypt from "bcrypt";

export const loginVeterinario = async (req, res) => {
  try {
    const { correo_electronico, contrasena } = req.body;

    if (!correo_electronico || !contrasena) {
      return res.status(400).json({ message: "Faltan datos para iniciar sesión." });
    }

    const [rows] = await pool.query(
      "SELECT * FROM veterinario_o_zootecnista WHERE correo_electronico = ?",
      [correo_electronico]
    );

    if (rows.length === 0) {
      return res.status(401).json({ message: "Correo o contraseña incorrectos." });
    }

    const vet = rows[0];

    const passwordMatches = await bcrypt.compare(contrasena, vet.contrasena);

    if (!passwordMatches) {
      return res.status(401).json({ message: "Correo o contraseña incorrectos." });
    }

    return res.status(200).json({
      id: vet.id,
      nombre: `${vet.primer_nombre} ${vet.primer_apellido}`,
      correo: vet.correo_electronico,
      tipoUsuario: "veterinario",
    });

  } catch (error) {
    console.error("❌ Error en loginVeterinario:", error);
    res.status(500).json({ message: "Error interno del servidor." });
  }
};
