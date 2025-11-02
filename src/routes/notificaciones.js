import express from "express";
import { obtenerNotificaciones } from "../controllers/Notificaciones.js";

const routerNotificaciones = express.Router();

// Ruta: /api/notificaciones/:rol/:id
routerNotificaciones.get("/:rol/:id", obtenerNotificaciones);

export default routerNotificaciones;
