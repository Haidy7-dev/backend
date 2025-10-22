import { Router } from "express";
import { getVeterinario } from "../controllers/Veterinario_o_zootecnista";
const routesVeterinario = Router();

routesVeterinario.get("/api/veterinario", getVeterinario);

export default routesVeterinario;
