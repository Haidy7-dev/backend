import express from "express";
import { registrarMascota, obtenerMascotasPorUsuario, obtenerMascotaPorId } from "../controllers/RegistroMascota.js";
import { actualizarPerfilMascota } from "../controllers/PerfilMascota.js";

const routerRegistroMascota = express.Router();

// Registrar nueva mascota
routerRegistroMascota.post("/api/mascotas", registrarMascota);

// Obtener mascotas por usuario
routerRegistroMascota.get("/api/mascotas/usuario/:id_usuario", obtenerMascotasPorUsuario);

// Obtener una mascota por su ID
routerRegistroMascota.get("/api/mascotas/:id", obtenerMascotaPorId);

// PUT → actualizar info de la mascota
routerRegistroMascota.put("/api/mascotas/:id", actualizarPerfilMascota);


export default routerRegistroMascota;

