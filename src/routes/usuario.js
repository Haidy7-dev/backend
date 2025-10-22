import { Router } from "express";
import { getUsuario, postUsuario } from "../controllers/Usuario";
const routesUsuario = Router();

routesUsuario.get("/api/usuario", getVeterinario);
routesUsuario.post("/api/usuario", postUsuario)

export default routesUsuario;