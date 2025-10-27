import express from "express";
import { loginVeterinario } from "../controllers/LoginVeterinario.js";
import { loginUsuario } from "../controllers/LoginUsuario.js";

const loginRoutes = express.Router();

loginRoutes.post("/api/loginVeterinario", loginVeterinario);
loginRoutes.post("/api/loginUsuario", loginUsuario);

export default loginRoutes;
