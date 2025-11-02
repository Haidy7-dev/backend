import { pool } from "../../utils/db.js";
import bcrypt from "bcrypt";

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
      especializacion,
      servicio,
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

    const hashedPassword = await bcrypt.hash(contrasena, 10); // Hash the password

    const [result] = await pool.query(
      `INSERT INTO veterinario_o_zootecnista
      (id, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido,
       correo_electronico, telefono, direccion_clinica, contrasena, foto)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        id,
        primer_nombre,
        segundo_nombre || null,
        primer_apellido,
        segundo_apellido || null,
        correo_electronico,
        telefono || null,
        direccion_clinica || null,
        hashedPassword, // Use the hashed password
        null, // Default foto to null
      ]
    );

    console.log("✅ Veterinario registrado con ID:", result.insertId);

    // Si se proporcionaron especializacion y servicio, insertar en tablas pivote
    let idEspecializacion = null;
    if (especializacion) {
      const [especializacionResult] = await pool.query(
        "SELECT id_especializaciones FROM especializaciones WHERE nombre_especializacion = ?",
        [especializacion]
      );
      if (especializacionResult.length > 0) {
        idEspecializacion = especializacionResult[0].id_especializaciones;
        console.log("Attempting to assign especializacion with ID:", idEspecializacion);
        await pool.query(
          "INSERT INTO p_veterinario_o_zootecnista_especializaciones (id_veterinario_o_zootecnista, id_especializaciones) VALUES (?, ?)",
          [id, idEspecializacion]
        );
        console.log("✅ Especialización asignada");
      } else {
        console.warn("⚠️ Especialización no encontrada:", especializacion);
      }
    }

    let idServicio = null;
    if (servicio) {
      const [servicioResult] = await pool.query(
        "SELECT id_servicio FROM servicio WHERE nombre_servicio = ?",
        [servicio]
      );
      if (servicioResult.length > 0) {
        idServicio = servicioResult[0].id_servicio;
        console.log("Attempting to assign servicio with ID:", idServicio);
        await pool.query(
          "INSERT INTO p_veterinario_servicio (id_veterinario_o_zootecnista, id_servicio) VALUES (?, ?)",
          [id, idServicio]
        );
        console.log("✅ Servicio asignado");
      } else {
        console.warn("⚠️ Servicio no encontrado:", servicio);
      }
    }

    return res.status(201).json({ message: "Veterinario registrado correctamente." });

  } catch (error) {
    console.error("❌ Error al registrar veterinario:", error);
    res.status(500).json({ message: "Error interno del servidor." });
  }
};
