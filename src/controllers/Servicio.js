import { pool } from "../../utils/db.js";

export const getServicio = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM servicio");
    console.log(result);
    res.json(result);
  } catch (err) {
    console.error("Error al obtener servicios:", err);
    return res.status(500).json({
      message: "Error al obtener servicios",
      error: err.message,
    });
  }
};