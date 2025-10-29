import express from "express";
import { getMascotaPorId, actualizarPerfilMascota } from "../controllers/PerfilMascota.js";

const router = express.Router();

// GET → traer info de la mascota
router.get("/api/mascota/:id", getMascotaPorId);

// PUT → actualizar info de la mascota
router.put("/api/mascota/:id", actualizarPerfilMascota);

export default router;


