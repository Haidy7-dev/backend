import Express from "express";
import cors from "cors";
import bodyParser from "body-parser";
import { PORT } from "./utils/config.js";
import routesEspecializacion from "./src/routes/especializaciones.js";
import routesServicio from "./src/routes/servicio.js";
import routesRaza from "./src/routes/raza.js";
import routesEspecie from "./src/routes/especie.js";
import routesFotos from "./src/routes/fotos.js";
import routesVeterinario from "./src/routes/veterinario_o_zootecnista.js";
import routesHorarios from "./src/routes/horarios.js";
import routesUsuario from "./src/routes/usuario.js";
import routesloginUsuario from "./src/routes/loginUsuario.js";
import routesloginVeterinario from "./src/routes/loginVeterinario.js";
import routesregistroVeterina from "./src/routes/registroVeterina.js";


const app = Express();

// Mantengo tu configuración CORS original (no se cambia)
app.use(
    // IP Salomé casa
    cors({ origin: ['http://localhost:3000', 'http://192.168.101.73'] })

    // IP Salomé datos
    // cors({ origin: ['http://localhost:3000', 'http://10.121.63.130'] })

    // IP Haidy casa
    // cors({ origin: ['http://localhost:3000', 'http://192.168.1.16'] })

    // IP Haidy datos
    // cors({ origin: ['http://localhost:3000', 'http://10.164.93.119'] })
);

// Middlewares
app.use(Express.json());
app.use(bodyParser.urlencoded({ extended: false }));

// Archivos estáticos
app.use(Express.static('src/public'));
app.use('/api', Express.static('src/public'));

// Rutas de API (todas las que ya tienes)
app.use(routesFotos);
app.use(routesEspecializacion);
app.use(routesServicio);
app.use(routesRaza);
app.use(routesEspecie);
app.use(routesVeterinario);
app.use(routesHorarios);
app.use(routesUsuario);
app.use(routesloginUsuario);
app.use(routesloginVeterinario);
app.use(routesregistroVeterina);

// Ruta base
app.get('/', (req, res) => {
  res.send({ data: "Patas sin barreras" });
});

// Iniciar servidor
app.listen(PORT, () => console.log(`Servidor corriendo en puerto ${PORT}`));


