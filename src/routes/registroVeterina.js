import express from "express";
import { postRegistrarVeterina, getRegistroVeterina } from "../controllers/RegistroVeterina.js";

const router = express.Router();

// Ruta POST para registrar veterinario
router.post("/api/registroVeterina", postRegistrarVeterina);
router.get("/api/registroVeterina", getRegistroVeterina);

export default router;
