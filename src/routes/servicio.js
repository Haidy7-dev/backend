import { Router } from "express";
import { getServicio } from "../controllers/Servicio.js";
const routesServicio = Router();

routesServicio.get("/api/servicio", getServicio);

export default routesServicio;
