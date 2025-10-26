import { getUsuario, postUsuario } from "../controllers/Usuario.js";
import { Router } from "express";

const routesUsuario = Router();

routesUsuario.get("/api/usuario", getUsuario);
routesUsuario.post("/api/usuario", postUsuario);

export default routesUsuario;
