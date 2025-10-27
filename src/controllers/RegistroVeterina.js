import { pool } from "../../utils/db.js";

export const getRegistroVeterina = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM veterinario_o_zootecnista");
    res.json(result);
  } catch (err) {
    console.error("❌ Error al obtener registros:", err);
    res.status(500).json({ message: "Error al obtener los registros de veterinarios." });
  }
};

export const postRegistrarVeterina = async (req, res) => {
  try {
    console.log("📥 Datos recibidos del frontend:", req.body);

    const {
      id,
      primer_nombre,
      segundo_nombre,
      primer_apellido,
      segundo_apellido,
      correo_electronico,
      telefono,
      direccion_clinica,
      contrasena,
    } = req.body;

    if (!id || !primer_nombre || !primer_apellido || !correo_electronico || !contrasena) {
      console.log("Faltan campos obligatorios");
      return res.status(400).json({ message: "Faltan campos obligatorios para el registro." });
    }

    const [existeVeterinario] = await pool.query(
      "SELECT * FROM veterinario_o_zootecnista WHERE id = ? OR correo_electronico = ?",
      [id, correo_electronico]
    );

    if (existeVeterinario.length > 0) {
      console.log("Veterinario ya existente:", existeVeterinario);
      return res.status(409).json({ message: "El ID o el correo ya están registrados." });
    }

    const [result] = await pool.query(
      `INSERT INTO veterinario_o_zootecnista 
      (id, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, 
       correo_electronico, telefono, direccion_clinica, contrasena)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        id,
        primer_nombre,
        segundo_nombre || null,
        primer_apellido,
        segundo_apellido || null,
        correo_electronico,
        telefono || null,
        direccion_clinica || null,
        contrasena,
      ]
    );

    console.log("✅ Veterinario registrado con ID:", result.insertId);
    return res.status(201).json({ message: "Veterinario registrado correctamente." });

  } catch (error) {
    console.error("❌ Error al registrar veterinario:", error);
    res.status(500).json({ message: "Error interno del servidor." });
  }
};
