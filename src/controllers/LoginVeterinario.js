import { pool } from "../../utils/db.js";

export const loginVeterinario = async (req, res) => {
  try {
    const { correo_electronico, contrasena } = req.body;

    if (!correo_electronico || !contrasena) {
      return res.status(400).json({ message: "Faltan datos para iniciar sesión." });
    }

    const [rows] = await pool.query(
      "SELECT id, primer_nombre, primer_apellido, correo_electronico FROM veterinario_o_zootecnista WHERE correo_electronico = ? AND contrasena = ?",
      [correo_electronico, contrasena]
    );

    if (rows.length === 0) {
      return res.status(404).json({ message: "Veterinario no encontrado o credenciales incorrectas." });
    }

    const vet = rows[0];

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
