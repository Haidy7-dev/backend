import { Router } from "express";
import { 
  getVeterinarios, 
  buscarVeterinarios 
} from "../controllers/Veterinario_o_zootecnista.js";

const routesVeterinario = Router();

// Obtener todos los veterinarios con calificaciones
routesVeterinario.get("/api/veterinarios", getVeterinarios);

// Buscar veterinarios por nombre
routesVeterinario.get("/api/veterinarios/buscar", buscarVeterinarios);

export default routesVeterinario;