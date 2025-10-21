import Express from "express";
import RutasLogin from "./src/routes/login.js"
import { PORT } from "./utils/config.js"
import cors from "cors"
import bodyParser from "body-parser";
import os from "os";
import FormData from "express-form-data";
import routesEspecializacion from "./src/routes/especializaciones.js";
import routesServicio from "./src/routes/servicio.js";
import routesRaza from "./src/routes/raza.js";
import routesEspecie from "./src/routes/especie.js";
import routesFotos from "./src/routes/fotos.js";


const app = Express();


// Configuración cors y entradas de texto
const options = {
    uploadDir: os.tmpdir(),
    autoClean: true
};

app.use(
    // IP Salomé datos
    // cors({ origin: ['http://localhost:3000', 'http://----------'] })

    // IP Salomé datos
    // cors({ origin: ['http://localhost:3000', 'http://10.121.63.130'] })

    //IP Haidy casa
    //cors({ origin: ['http://localhost:3000', 'http://192.168.1.16'] })
    //IP Haidy datos
    cors({ origin: ['http://localhost:3000', 'http://10.164.93.119'] })
);

app.use(Express.static('src/public'));
app.use('/api', Express.static('src/public'))

app.use(FormData.parse(options))
app.use(bodyParser.urlencoded({ extended: false }));
// Configuración cors y entradas de texto

/* app.use((req, res, next) => {
    console.log( req.headers.authorization)
    next();
}); */

// Rutas de API
app.use(RutasLogin)
app.use(routesEspecializacion)
app.use(routesServicio)
app.use(routesRaza)
app.use(routesEspecie)
app.use(routesFotos)


// Rutas de API

app.get('/', (req, res) => {
    res.send({ data: "Patas sin barreras" })
})


app.listen(PORT);

