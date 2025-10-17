import { Router } from "express";
import { getEspecie } from "../controllers/Especie.js";
const routesespecie = Router();

routesespecie.get("/api/especie", getEspecie);

export default routesespecie;