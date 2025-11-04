import express from "express";
import cors from "cors";
import path from "path";
import { PORT } from "./utils/config.js";

// Importación de rutas
import routesEspecializacion from "./src/routes/especializaciones.js";
import routesServicio from "./src/routes/servicio.js";
import routesRaza from "./src/routes/raza.js";
import routesEspecie from "./src/routes/especie.js";
import routesFotos from "./src/routes/fotos.js";
import routesVeterinario from "./src/routes/veterinario_o_zootecnista.js";
import routesHorarios from "./src/routes/horarios.js";
import routesUsuario from "./src/routes/usuario.js";
import routesregistroVeterina from "./src/routes/registroVeterina.js";
import routescitasVeterinario from "./src/routes/citasVeterinario.js";
import routesresumenCitas from "./src/routes/resumenCitas.js";
import routesCreateCita from "./src/routes/createCita.js";
import routerRegistroMascota from "./src/routes/registroMascota.js";
import authRoutes from "./src/routes/auth.js";
import routercitasDueno from "./src/routes/citaDueno.js";
import routerPerfilMascota from "./src/routes/perfilMascota.js";
import routerCalificaciones from "./src/routes/crearCalificacion.js";
import routerVerificarUsuario from "./src/routes/verificarUsuario.js";


const app = express();

app.use((req, res, next) => {
  console.log(`Request received: ${req.method} ${req.url}`);
  next();
});

// 🧩 Configuración CORS
app.use(
  cors({
    origin: [
      "http://localhost:3000",
      "http://192.168.101.73", // ✅ IP 
      "http://localhost:8081",
    ],
  })
);

// 🧩 Middlewares principales
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

// 🧩 Rutas API
// ⚠️ IMPORTANTE: cada archivo de rutas ya define su propio prefijo.
// Por eso no uses `app.use("/api", routesRegistroVeterina)` aquí, ya que duplicaría el prefijo.
app.use(routesFotos);
app.use(routesEspecializacion);
app.use(routesServicio);
app.use(routesRaza);
app.use(routesEspecie);
app.use(routesVeterinario);
app.use(routesHorarios);
app.use(routesUsuario);
app.use(routesregistroVeterina);
app.use(routescitasVeterinario);
app.use("/api/resumencitas", routesresumenCitas);
app.use(routesCreateCita);
app.use(routerRegistroMascota);
app.use("/api", authRoutes);
app.use(routercitasDueno);
app.use(routerPerfilMascota);
app.use(routerCalificaciones);
app.use(routerVerificarUsuario);
app.use(routerVerificarUsuario);


// 🧩 Archivos estáticos
app.use(express.static("src/public"));
app.use("/api", express.static("src/public"));
app.use("/pethub", express.static(path.join(process.cwd(), "backend", "src", "fotos")));

// 🧩 Ruta base
app.get("/", (req, res) => {
  res.send({ data: "🐾 Patas sin barreras - API Activa" });
});

// 🧩 Middleware global de errores
app.use((err, req, res, next) => {
  console.error("❌ Error global:", err);
  res.status(500).json({ message: "Error interno del servidor", error: err.message });
});

// 🧩 Inicio del servidor
app.listen(PORT, () => {
  console.log(`🚀 Servidor corriendo en http://192.168.101.73:${PORT}`);
});



