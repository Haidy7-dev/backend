import { pool } from "../../utils/db.js";
import bcrypt from "bcrypt";

/**
 * Obtener todos los usuarios
 */
export const getUsuario = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM usuario");
    res.json(result);
  } catch (err) {
    console.error("❌ Error al obtener usuarios:", err);
    res.status(500).json({ message: "Error al obtener los usuarios" });
  }
};

/**
 * Obtener usuario por ID
 */
export const getUsuarioPorId = async (req, res) => {
  try {
    const { id } = req.params;
    const [rows] = await pool.query("SELECT * FROM usuario WHERE id = ?", [id]);

    if (rows.length === 0) {
      return res.status(404).json({ message: "Usuario no encontrado" });
    }

    res.json(rows[0]);
  } catch (error) {
    console.error("❌ Error al obtener usuario:", error);
    res.status(500).json({ message: "Error del servidor" });
  }
};

/**
 * Registrar un nuevo usuario
 */
export const postUsuario = async (req, res) => {
  try {
    const {
      id,
      primer_nombre,
      segundo_nombre,
      primer_apellido,
      segundo_apellido,
      correo_electronico,
      direccion,
      telefono,
      n_de_mascotas,
      contrasena,
      id_veterinario_o_zootecnista,
    } = req.body;

    if (!id || !primer_nombre || !primer_apellido || !correo_electronico || !contrasena) {
      return res.status(400).json({ message: "Faltan campos obligatorios para el registro." });
    }

    const [existe] = await pool.query(
      "SELECT * FROM usuario WHERE id = ? OR correo_electronico = ?",
      [id, correo_electronico]
    );

    if (existe.length > 0) {
      return res.status(409).json({ message: "El usuario o correo ya están registrados." });
    }

    const hashedPassword = await bcrypt.hash(contrasena, 10);

    await pool.query(
      `INSERT INTO usuario 
      (id, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, 
       correo_electronico, direccion, telefono, n_de_mascotas, contrasena, id_veterinario_o_zootecnista)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        id,
        primer_nombre,
        segundo_nombre || null,
        primer_apellido,
        segundo_apellido || null,
        correo_electronico,
        direccion || null,
        telefono || null,
        n_de_mascotas || 0,
        hashedPassword,
        id_veterinario_o_zootecnista || null,
      ]
    );

    res.status(201).json({ message: "Usuario registrado correctamente." });
  } catch (error) {
    console.error("❌ Error al registrar usuario:", error);
    res.status(500).json({ message: "Error interno del servidor." });
  }
};

/**
 * Actualizar datos del usuario
 */
export const actualizarUsuario = async (req, res) => {
  const { id } = req.params;
  const {
    primer_nombre,
    segundo_nombre,
    primer_apellido,
    segundo_apellido,
    correo_electronico,
    direccion,
    telefono,
    n_de_mascotas,
    foto,
  } = req.body;

  try {
    const [result] = await pool.query(
      `UPDATE usuario 
       SET primer_nombre=?, segundo_nombre=?, primer_apellido=?, segundo_apellido=?, 
           correo_electronico=?, direccion=?, telefono=?, n_de_mascotas=?, foto=?
       WHERE id=?`,
      [
        primer_nombre,
        segundo_nombre,
        primer_apellido,
        segundo_apellido,
        correo_electronico,
        direccion,
        telefono,
        n_de_mascotas,
        foto,
        id,
      ]
    );

    if (result.affectedRows === 0)
      return res.status(404).json({ message: "Usuario no encontrado" });

    res.json({ message: "Usuario actualizado correctamente" });
  } catch (error) {
    console.error("❌ Error al actualizar usuario:", error);
    res.status(500).json({ message: "Error al actualizar el usuario" });
  }
};
