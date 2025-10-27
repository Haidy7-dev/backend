import { Router } from "express";
import { CreateCita } from "../controllers/createCita.js";

const routesCreateCita = Router();

routesCreateCita.post('/api/citas', CreateCita);

export default routesCreateCita;
