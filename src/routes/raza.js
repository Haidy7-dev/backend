import { Router } from "express";
import { pool } from "../../utils/db.js";

const routesRaza = Router();

routesRaza.get("/api/raza", async (req, res) => {
  const query = "SELECT id as id_raza, nombre, id_especie FROM raza";
  try {
    const [rows] = await pool.query(query);
    res.status(200).json(rows);
  } catch (error) {
    console.error("Error al obtener razas:", error);
    res.status(500).json({ message: "Error interno del servidor" });
  }
});

export default routesRaza;