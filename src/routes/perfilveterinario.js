import express from "express";
import {getVeterinarioPorId,actualizarVeterinario,} from "../controllers/PerfilVeterinario.js";

const router = express.Router();

// Obtener veterinario por ID
router.get("/:id", getVeterinarioPorId);

// Actualizar datos del veterinario
router.put("/:id", actualizarVeterinario);

export default router;
