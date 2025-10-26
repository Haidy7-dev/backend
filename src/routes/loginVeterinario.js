import { Router } from "express";
import { loginVeterinario } from "../controllers/LoginVeterinario.js";

const routesLoginVeterinario = Router();

// Endpoint para veterinario
routesLoginVeterinario.post("/api/LoginVeterinario", loginVeterinario);

export default routesLoginVeterinario;
