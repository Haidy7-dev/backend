import express from 'express';
import { verificarUsuario } from '../controllers/verificarUsuario.js';

const router = express.Router();

router.post('/api/verificar-usuario', verificarUsuario);

export default router;
