import { Router } from "express";
import { getResumenCita } from "../controllers/ResumenCitas.js";

const routesresumenCitas = Router();

/**
 * GET /:idCita
 * Obtiene el resumen completo de una cita específica
 * La URL completa dependerá del prefijo que pongas en index.js
 */
routesresumenCitas.get("/api/ResumenCitas/:idCita", getResumenCita);

export default routesresumenCitas;


