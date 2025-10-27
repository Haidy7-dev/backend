import { Router } from "express";
import { getRegistroVeterina, postRegistrarVeterina } from "../controllers/RegistroVeterina.js";


const routesRegistroVeterina = Router();

routesRegistroVeterina.get("/api/registroVeterina", getRegistroVeterina);
routesRegistroVeterina.post("/api/registroVeterina", postRegistrarVeterina);

export default routesRegistroVeterina;
