import { pool } from "../../utils/db.js";

/**
 * 🟢 OBTENER TODOS LOS USUARIOS
 * GET /api/usuarios
 */
export const getUsuario = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM usuario");
    console.log(result);
    res.json(result);
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      message: "Error al obtener los usuarios",
    });
  }
};

/**
 * 🟡 CREAR O ACTUALIZAR UN USUARIO
 * POST /api/usuarios
 */
export const postUsuario = async (req, res) => {
  try {
    // Extraemos los datos que vienen del frontend (React Native)
    const {
      nombre,
      identificacion,
      correo,
      direccion,
      telefono,
      numero_mascotas,
    } = req.body;

    // Validamos los campos requeridos
    if (!nombre || !identificacion || !correo) {
      return res.status(400).json({ message: "Faltan datos requeridos" });
    }

    // ✅ Verificar si el usuario ya existe
    const [existeUsuario] = await pool.query(
      "SELECT * FROM usuario WHERE identificacion = ?",
      [identificacion]
    );

    if (existeUsuario.length > 0) {
      // 🟠 Si el usuario ya existe → ACTUALIZAMOS
      await pool.query(
        `UPDATE usuario 
         SET nombre = ?, correo = ?, direccion = ?, telefono = ?, numero_mascotas = ? 
         WHERE identificacion = ?`,
        [nombre, correo, direccion, telefono, numero_mascotas, identificacion]
      );

      console.log(`Usuario actualizado: ${nombre}`);
      return res.status(200).json({ message: "Usuario actualizado correctamente" });
    } else {
      // 🟢 Si el usuario no existe → INSERTAMOS
      const [result] = await pool.query(
        `INSERT INTO usuario (nombre, identificacion, correo, direccion, telefono, numero_mascotas)
         VALUES (?, ?, ?, ?, ?, ?)`,
        [nombre, identificacion, correo, direccion, telefono, numero_mascotas]
      );

      console.log("Usuario creado con ID:", result.insertId);
      return res.status(201).json({
        message: "Usuario guardado correctamente",
        id: result.insertId,
      });
    }
  } catch (error) {
    console.error("❌ Error al guardar o actualizar el usuario:", error);
    res.status(500).json({ message: "Error interno del servidor" });
  }
};
