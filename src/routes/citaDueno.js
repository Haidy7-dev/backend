import express from "express";
import { getCitasBasicasDueno, actualizarEstadoCitaDueno } from "../controllers/CitaDueno.js";

const routercitasDueno = express.Router();

// 🔹 Obtener todas las citas del dueño
routercitasDueno.get("/api/citasDueno/:idDueno", getCitasBasicasDueno);

// 🔹 Actualizar estado de una cita
routercitasDueno.put("/api/citasDueno/estado/:id", actualizarEstadoCitaDueno);

export default routercitasDueno;
