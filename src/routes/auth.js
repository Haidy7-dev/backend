import express from "express";
import { loginVeterinario } from "../controllers/LoginVeterinario.js";
import { loginUsuario } from "../controllers/LoginUsuario.js";

const authRoutes = express.Router();

authRoutes.post("/loginVeterinario", loginVeterinario);
authRoutes.post("/loginUsuario", loginUsuario);

export default authRoutes;
