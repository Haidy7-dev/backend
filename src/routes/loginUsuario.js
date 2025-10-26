import { Router } from "express";
import { loginUsuario } from "../controllers/LoginUsuario.js";

const routesLoginUsuario = Router();

// Ruta POST para login
routesLoginUsuario.post("/api/LoginUsuario", loginUsuario);

export default routesLoginUsuario;



