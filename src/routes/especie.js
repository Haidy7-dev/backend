import { Router } from "express";
import { getEspecie } from "../controllers/Especie.js";
const routesEspecie = Router();

routesEspecie.get("/api/especie", getEspecie);

export default routesEspecie;