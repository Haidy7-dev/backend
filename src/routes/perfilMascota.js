import express from "express";
import { obtenerPerfilMascota, actualizarPerfilMascota } from "../controllers/PerfilMascota.js";

const router = express.Router();

// GET → traer info de la mascota
router.get("/:idMascota", obtenerPerfilMascota);

// PUT → actualizar info de la mascota
router.put("/:idMascota", actualizarPerfilMascota);

export default router;
