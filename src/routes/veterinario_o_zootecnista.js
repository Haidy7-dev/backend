import { Router } from "express";
import {
  getVeterinarios,
  buscarVeterinarios,
  getVeterinarioDetalle,
  getCitasDia,
} from "../controllers/Veterinario_o_zootecnista.js";

const routesVeterinario = Router();

// Obtener todos los veterinarios con calificaciones
routesVeterinario.get("/api/veterinarios", getVeterinarios);

// Buscar veterinarios por nombre
routesVeterinario.get("/api/veterinarios/buscar", buscarVeterinarios);

// Obtener veterinario por ID (detalle + horarios + servicios)
routesVeterinario.get("/api/veterinarios/detalle/:id", getVeterinarioDetalle);

// Obtener las citas de un veterinario
routesVeterinario.get("/api/veterinarios/:id/citas", getCitasDia);

export default routesVeterinario;


