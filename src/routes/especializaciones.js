import { Router } from "express";
import { getEspecializaciones } from "../controllers/Especializaciones.js";
const routesEspecializacion = Router();

routesEspecializacion.get("/api/especializaciones", getEspecializaciones);

export default routesEspecializacion;
