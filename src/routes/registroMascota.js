import express from "express";
import { registrarMascota, obtenerMascotasPorUsuario } from "../controllers/RegistroMascota.js";

const routerRegistroMascota = express.Router();

// Registrar nueva mascota
routerRegistroMascota.post("/api/mascota", registrarMascota);

// Obtener mascotas por usuario
routerRegistroMascota.get("/api/mascota/:id_usuario", obtenerMascotasPorUsuario);

export default routerRegistroMascota;

