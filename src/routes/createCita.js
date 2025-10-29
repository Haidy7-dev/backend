import { Router } from "express";
import { CreateCita } from "../controllers/CreateCita.js";

const routesCreateCita = Router();

routesCreateCita.post('/api/citas', CreateCita);

export default routesCreateCita;


