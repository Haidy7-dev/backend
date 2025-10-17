import Express from "express";
import RutasLogin from "./src/routes/login.js"
import { PORT } from "./utils/config.js"
import cors from "cors"
import bodyParser from "body-parser";
import os from "os";
import FormData from "express-form-data";
import routesEspecializacion from "./src/routes/especializaciones.js";
import routesServicio from "./src/routes/servicio.js";
import routesraza from "./src/routes/raza.js";
import routessexo from "./src/routes/sexo.js";
import routesespecie from "./src/routes/especie.js";
import routesFotos from "./src/routes/fotos.js";




const app = Express();


// Configuración cors y entradas de texto
const options = {
    uploadDir: os.tmpdir(),
    autoClean: true
};

app.use(
    cors({ origin: ['http://localhost:3000', 'http://10.121.63.130'] })
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
app.use(routesraza)
app.use(routessexo)
app.use(routesespecie)
app.use(routesFotos)


// Rutas de API

app.get('/', (req, res) => {
    res.send({ data: "Patas sin barreras" })
})


app.listen(PORT);

