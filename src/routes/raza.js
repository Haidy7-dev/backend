import { Router } from "express";
import { getraza } from "../controllers/Raza.js";   
const routesRaza = Router();

routesRaza.get("/api/raza", getraza);

export default routesRaza;