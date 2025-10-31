import express from "express";
import {getCitasBasicasVeterinario, actualizarEstadoCita, } from "../controllers/CitasVeterinario.js";

const routescitasVeterinario = express.Router();

// Obtener todas las citas básicas del veterinario
routescitasVeterinario.get("/api/citasVeterinario/:idVet", getCitasBasicasVeterinario);

// Actualizar estado de una cita específica
routescitasVeterinario.put("/api/citasVeterinario/:id/estado", actualizarEstadoCita);

export default routescitasVeterinario;



