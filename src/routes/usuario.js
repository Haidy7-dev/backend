import express from "express";
import {
  getUsuario,
  postUsuario,
  getUsuarioPorId,
  actualizarUsuario,
} from "../controllers/Usuario.js";

const router = express.Router();

// Obtener todos los usuarios
router.get("/api/usuario", getUsuario);

// Obtener un usuario por ID
router.get("/api/usuario/:id", getUsuarioPorId);

// Registrar usuario nuevo
router.post("/api/usuario", postUsuario);

// Actualizar usuario
router.put("/api/usuario/:id", actualizarUsuario);

export default router;

