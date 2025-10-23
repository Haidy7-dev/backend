import { pool } from "../../utils/db.js";

// 📌 Obtener todos los horarios
export const getHorarios = async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT * 
       FROM horarios 
       ORDER BY FIELD(dia_semana,'Lunes','Martes','Miércoles','Jueves','Viernes','Sábado','Domingo')`
    );
    res.json(rows);
  } catch (error) {
    console.error("Error al obtener horarios:", error);
    res.status(500).json({ message: "Error al obtener horarios" });
  }
};

// 📌 Crear un nuevo horario
export const createHorario = async (req, res) => {
  try {
    const { dia_semana, hora_inicio, hora_finalizacion } = req.body;

    if (!dia_semana || !hora_inicio || !hora_finalizacion) {
      return res.status(400).json({
        message: "Faltan datos obligatorios: día, hora de inicio o finalización",
      });
    }

    const [result] = await pool.query(
      "INSERT INTO horarios (dia_semana, hora_inicio, hora_finalizacion) VALUES (?, ?, ?)",
      [dia_semana, hora_inicio, hora_finalizacion]
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

// 📌 Eliminar un horario (opcional)
export const deleteHorario = async (req, res) => {
  try {
    const { id } = req.params;
    await pool.query("DELETE FROM horarios WHERE id = ?", [id]);
    res.json({ message: "Horario eliminado correctamente" });
  } catch (error) {
    console.error("Error al eliminar horario:", error);
    res.status(500).json({ message: "Error al eliminar horario" });
  }
};
