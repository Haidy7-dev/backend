import express from "express";
import { CrearCalificacion } from "../controllers/CrearCalificacion.js";

const routerCalificaciones = express.Router();

routerCalificaciones.post("/api/calificaciones", CrearCalificacion);

export default routerCalificaciones;
