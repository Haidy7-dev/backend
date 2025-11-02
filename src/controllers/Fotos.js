import multer from "multer";
import path from "path";
import fs from "fs";
import { pool } from "../../utils/db.js";

const fotosDir = path.join(process.cwd(), "src", "fotos");

// Crear carpeta si no existe
if (!fs.existsSync(fotosDir)) {
  fs.mkdirSync(fotosDir, { recursive: true });
}

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, fotosDir); // ✅ usar la ruta absoluta
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    const ext = path.extname(file.originalname);
    cb(null, file.fieldname + "-" + uniqueSuffix + ext);
  },
});

const upload = multer({ storage });
// --- Controladores --- //
export const subirFotoVeterinario = [
  upload.single("foto"),
  async (req, res) => {
    console.log("Archivo recibido:", req.file);
    console.log("Body:", req.body);
    console.log("Params:", req.params);

    try {
      if (!req.file) {
        return res.status(400).json({ error: "No se envió ninguna foto" });
      }

      const { id } = req.params;
      const ruta = req.file.filename;

      await pool.query(
        "UPDATE veterinario_o_zootecnista SET foto = ? WHERE id = ?",
        [ruta, id]
      );

      res.json({ message: "Foto del veterinario guardada", ruta });
    } catch (error) {
      console.error("Error al subir foto:", error);
      res
        .status(500)
        .json({
          error: "Error al subir la foto del veterinario y/o zootecnista",
        });
    }
  },
];

export const subirFotoUsuario = [
  upload.single("foto"),
  async (req, res) => {
     try {
      if (!req.file)
        return res.status(400).json({ error: "No se envió ninguna foto" });

      const { id } = req.params;
      const ruta = req.file.filename;
      await pool.query("UPDATE usuario SET foto = ? WHERE id = ?", [ruta, id]);
      res.json({ message: "Foto del usuario guardada", ruta });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: "Error al subir la foto del usuario" });
    }
  },
];

export const subirFotoMascota = [
  upload.single("foto"),
  async (req, res) => {
    try {
      if (!req.file)
        return res.status(400).json({ error: "No se envió ninguna foto" });

      const { id } = req.params;
      const ruta = req.file.filename;
      await pool.query("UPDATE mascota SET foto = ? WHERE id = ?", [ruta, id]);
      res.json({ message: "Foto de la mascota guardada", ruta });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: "Error al subir la foto de la mascota" });
    }
  },
];
