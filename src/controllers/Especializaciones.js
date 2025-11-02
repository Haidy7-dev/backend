import { pool } from "../../utils/db.js";

export const getEspecializaciones = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT id, nombre FROM especializaciones");
    console.log(result);
    res.json(result);
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      message: "Token Invalido",
    });
  }
};
