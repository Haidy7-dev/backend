import { pool } from "../../utils/db.js";

export const getServicio = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT nombre FROM servicio");
    console.log(result);
    res.json(result);
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      message: "Token Invalido",
    });
  }
};