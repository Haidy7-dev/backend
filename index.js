import Express from "express";
import RutasLogin from "./src/routes/login.js"

import { PORT } from "./utils/config.js"
import cors from "cors"
import bodyParser from "body-parser";
import os from "os";
import FormData from "express-form-data";
import routesEspecializacion from "./src/routes/especializaciones.js";
const app = Express();


// Configuración cors y entradas de texto
const options = {
    uploadDir: os.tmpdir(),
    autoClean: true
};

app.use(
    cors({ origin: ['http://localhost:3000', 'http://127.0.0.1:5173'] })
);

app.use(Express.static('src/public'));
app.use('/api', Express.static('src/public'))

app.use(FormData.parse(options))
app.use(bodyParser.json());
// Configuración cors y entradas de texto

/* app.use((req, res, next) => {
    console.log( req.headers.authorization)
    next();
}); */

// Rutas de API
app.use(RutasLogin)
app.use(routesEspecializacion)


// Rutas de API

app.get('/', (req, res) => {
    res.send({ data: "Patas sin barreras" })
})


app.listen(PORT);

