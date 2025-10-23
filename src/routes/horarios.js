import { Router } from "express";
import { getHorarios, createHorario, deleteHorario } from "../controllers/Horarios.js";

const routesHorarios = Router();

// 📌 Endpoints
routesHorarios.get("/api/horarios", getHorarios);       // Obtener horarios
routesHorarios.post("/api/horarios", createHorario);    // Crear horario
routesHorarios.delete("/api/horarios/:id", deleteHorario); // Eliminar horario (opcional)

export default routesHorarios;
