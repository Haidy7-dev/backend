import { pool } from "../../utils/db.js";

export const getVeterinario = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM veterinario_o_zootecnista");
    console.log(result);
    res.json(result);
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      message: "Token Invalido",
    });
  }
};