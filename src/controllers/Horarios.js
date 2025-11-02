import { pool } from "../../utils/db.js";

// 📌 Obtener todos los horarios
export const getHorariosAll = async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT * 
       FROM horarios 
       ORDER BY FIELD(dia_semana,'Lunes','Miércoles','Martes','Jueves','Viernes','Sábado','Domingo')`
    );
    res.json(rows);
  } catch (error) {
    console.error("Error al obtener horarios:", error);
    res.status(500).json({ message: "Error al obtener horarios" });
  }
};

// 📌 Obtener horarios por ID de veterinario
export const getHorariosByVetId = async (req, res) => {
  try {
    const { id_veterinario_o_zootecnista } = req.params;
    const [rows] = await pool.query(
      `SELECT * 
       FROM horarios 
       WHERE id_veterinario_o_zootecnista = ?
       ORDER BY FIELD(dia_semana,'Lunes','Miércoles','Martes','Jueves','Viernes','Sábado','Domingo')`,
      [id_veterinario_o_zootecnista]
    );

    if (rows.length === 0) {
      return res.status(404).json({ message: "Horarios no encontrados para este veterinario" });
    }

    res.json(rows);
  } catch (error) {
    console.error("Error al obtener horarios por ID de veterinario:", error);
    res.status(500).json({ message: "Error al obtener horarios del veterinario" });
  }
};

// 📌 Crear un nuevo horario
export const createHorario = async (req, res) => {
  try {
    const { dia_semana, hora_inicio, hora_finalizacion, id_veterinario_o_zootecnista } = req.body;

    if (!dia_semana || !hora_inicio || !hora_finalizacion || !id_veterinario_o_zootecnista) {
      return res.status(400).json({
        message: "Faltan datos obligatorios: día, hora de inicio, finalización o ID del veterinario",
      });
    }

    const [result] = await pool.query(
      "INSERT INTO horarios (dia_semana, hora_inicio, hora_finalizacion, id_veterinario_o_zootecnista) VALUES (?, ?, ?, ?)",
      [dia_semana, hora_inicio, hora_finalizacion, id_veterinario_o_zootecnista]
    );

    res.status(201).json({
      message: "Horario registrado correctamente",
      id: result.insertId,
    });
  } catch (error) {
    console.error("Error al crear horario:", error);
    res.status(500).json({ message: "Error al crear horario" });
  }
};

// 📌 Eliminar un horario por ID de horario
export const deleteHorario = async (req, res) => {
  try {
    const { id } = req.params;
    const [result] = await pool.query("DELETE FROM horarios WHERE id = ?", [id]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Horario no encontrado" });
    }

    res.json({ message: "Horario eliminado correctamente" });
  } catch (error) {
    console.error("Error al eliminar horario:", error);
    res.status(500).json({ message: "Error al eliminar horario" });
  }
};

// 📌 Eliminar horarios por ID de veterinario
export const deleteHorariosByVetId = async (req, res) => {
  try {
    const { id_veterinario_o_zootecnista } = req.params;
    const [result] = await pool.query("DELETE FROM horarios WHERE id_veterinario_o_zootecnista = ?", [id_veterinario_o_zootecnista]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "No se encontraron horarios para este veterinario" });
    }

    res.json({ message: `Horarios para el veterinario ${id_veterinario_o_zootecnista} eliminados correctamente` });
  } catch (error) {
    console.error("Error al eliminar horarios por ID de veterinario:", error);
    res.status(500).json({ message: "Error al eliminar horarios del veterinario" });
  }
};
