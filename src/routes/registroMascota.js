import express from "express";
import { registrarMascota, obtenerMascotasPorUsuario } from "../controllers/RegistroMascota.js";

const routerRegistroMascota = express.Router();

// Ruta para registrar una nueva mascota
routerRegistroMascota.post("/api", registrarMascota);

// Ruta para obtener las mascotas de un usuario
routerRegistroMascota.get("/api/:id_usuario", obtenerMascotasPorUsuario);

export default routerRegistroMascota;
