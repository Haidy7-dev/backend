import { Router } from "express";
import { getRaza } from "../controllers/Raza.js";   
const routesRaza = Router();

routesRaza.get("/api/raza", getRaza);

export default routesRaza;