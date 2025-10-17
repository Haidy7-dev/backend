import { Router } from "express";
import { subirFotoMascota, subirFotoUsuario, subirFotoVeterinario } from "../controllers/fotos.js";

const routesFotos = Router();

routesFotos.post('/upload/veterinario/:id', subirFotoVeterinario);
routesFotos.post('/upload/usuario/:id', subirFotoUsuario);
routesFotos.post('/upload/mascota/:id', subirFotoMascota);

export default routesFotos;
