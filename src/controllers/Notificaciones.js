import { pool } from "../../utils/db.js";


// 🔹 Función para formatear fecha legible
function formatearFecha(fecha) {
  return new Date(fecha).toLocaleDateString("es-ES", {
    weekday: "long",
    year: "numeric",
    month: "long",
    day: "numeric",
  });
}

// 🔹 Controlador principal
import { pool } from "../../utils/db.js";


// 🔹 Función para formatear fecha legible
function formatearFecha(fecha) {
  return new Date(fecha).toLocaleDateString("es-ES", {
    weekday: "long",
    year: "numeric",
    month: "long",
    day: "numeric",
  });
}

// 🔹 Controlador principal
export const obtenerNotificaciones = async (req, res) => {
  const { rol, id } = req.params;
  const ahora = new Date();

  try {
    const [citas] = await pool.query(
      `SELECT fecha, hora_inicio, id_usuario, id_veterinario_o_zootecnista 
       FROM citas 
       WHERE ${rol === "veterinario" ? "id_veterinario_o_zootecnista" : "id_usuario"} = ?`,
      [id]
    );

    const notificaciones = [];

    // 🔹 Notificaciones fijas
    if (rol === "veterinario") {
      notificaciones.push(
        { mensaje: "¡Recuerda actualizar tu perfil!", tipo: "fija" },
        { mensaje: "¡Recuerda estar pendiente de tus citas!", tipo: "fija" }
      );
    } else {
      notificaciones.push(
        { mensaje: "¡Recuerda actualizar tu perfil!", tipo: "fija" },
        { mensaje: "¡Agenda una cita de chequeo para tu mascota!", tipo: "fija" }
      );
    }

    // 🔹 Notificaciones dinámicas
    for (const cita of citas) {
      const fechaCita = new Date(`${cita.fecha}T${cita.hora_inicio}`);
      const diferenciaMinutos = (fechaCita - ahora) / 1000 / 60;
      const diferenciaDias = Math.floor(diferenciaMinutos / 1440);

      if (rol === "veterinario") {
        if (diferenciaDias >= 0 && diferenciaDias <= 7) {
          notificaciones.push({
            mensaje: `Tienes una nueva cita para el ${formatearFecha(
              cita.fecha
            )}, ¡Revísala en tu agenda!`,
            tipo: "nueva",
          });
        }
        if (diferenciaMinutos > 0 && diferenciaMinutos <= 20) {
          notificaciones.push({
            mensaje: "Tu cita comenzará pronto, ¡prepárate!",
            tipo: "urgente",
          });
        }
      }

      if (rol === "usuario") {
        if (diferenciaDias === 1) {
          notificaciones.push({
            mensaje:
              "Tu mascota tiene programada una cita mañana, ¡Revísala en tu agenda!",
            tipo: "nueva",
          });
        }
        if (diferenciaMinutos > 0 && diferenciaMinutos <= 20) {
          notificaciones.push({
            mensaje: "La cita comenzará pronto, ¡prepárate!",
            tipo: "urgente",
          });
        }
      }
    }

    res.json({ notificaciones });
  } catch (error) {
    console.error("Error al obtener notificaciones:", error);
    res.status(500).json({ error: "Error al obtener notificaciones" });
  }
};
