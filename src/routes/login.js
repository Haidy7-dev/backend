import { Router } from "express";
import { getLogin } from "../controllers/Login.js";
const router = Router();

 router.get('/api/login', getLogin)
 

export default router;