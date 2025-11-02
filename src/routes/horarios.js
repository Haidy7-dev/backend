import { Router } from "express";
import { getHorariosAll, getHorariosByVetId, createHorario, deleteHorario, deleteHorariosByVetId } from "../controllers/Horarios.js";

const routesHorarios = Router();

// 📌 Endpoints
routesHorarios.get("/api/horarios", getHorariosAll);       // Obtener todos los horarios
routesHorarios.get("/api/horarios/:id_veterinario_o_zootecnista", getHorariosByVetId); // Obtener horarios por ID de veterinario
routesHorarios.post("/api/horarios", createHorario);    // Crear horario
routesHorarios.delete("/api/horarios/:id", deleteHorario); // Eliminar horario por ID de horario
routesHorarios.delete("/api/horarios/veterinario/:id_veterinario_o_zootecnista", deleteHorariosByVetId); // Eliminar horarios por ID de veterinario

export default routesHorarios;
