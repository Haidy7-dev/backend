import { pool } from "../../utils/db.js";


/**
 *  OBTENER TODOS LOS USUARIOS
 * post /api/usuarios
 */
export const getRegistroVeterina = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM usuario");
    console.log(result);
    res.json(result);
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      message: "Error al obtener los registros de veterinaria",
    });
  }
};

/**
 * REGISTRAR UN NUEVO VETERINARIO
 * POST /api/RegistroVeterinario
 */
export const postRegistrarVeterina = async (req, res) => {
  try {
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

    // ✅ Validación de campos obligatorios
    if (
      !id ||
      !primer_nombre ||
      !primer_apellido ||
      !correo_electronico ||
      !contrasena
    ) {
      return res
        .status(400)
        .json({ message: "Faltan campos obligatorios para el registro." });
    }

    // ✅ Verificar si el correo o ID ya existen
    const [existeVeterinario] = await pool.query(
      "SELECT * FROM veterinario_o_zootecnista WHERE id = ? OR correo_electronico = ?",
      [id, correo_electronico]
    );

    if (existeVeterinario.length > 0) {
      return res
        .status(409)
        .json({ message: "El ID o el correo ya están registrados." });
    }

    // ✅ Insertar nuevo veterinario
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
    return res
      .status(201)
      .json({ message: "Veterinario registrado correctamente." });
  } catch (error) {
    console.error("❌ Error al registrar veterinario:", error);
    res.status(500).json({ message: "Error interno del servidor." });
  }
};
