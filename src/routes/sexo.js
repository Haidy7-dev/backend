import { Router } from "express";
import { getsexo} from "../controllers/Sexo.js";
const routessexo = Router();

routessexo.get("/api/sexo", getsexo);

export default routessexo;
