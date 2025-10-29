import { pool } from "../../utils/db.js";

function addMinutesToTime(timeStr, minutes) {
  const [hh, mm, ss] = timeStr.split(":").map((n) => parseInt(n, 10));
  const totalMin = hh * 60 + mm + minutes;
  const newH = Math.floor((totalMin % (24 * 60)) / 60);
  const newM = totalMin % 60;
  return `${String(newH).padStart(2, "0")}:${String(newM).padStart(2, "0")}:00`;
}

export const CreateCita = async (req, res) => {
  try {
    const {
      fecha,
      hora_inicio,
      id_veterinario,
      id_servicio,
      id_usuario,
      id_mascota,
    } = req.body;

    if (!fecha || !hora_inicio || !id_veterinario || !id_servicio || !id_usuario) {
      return res.status(400).json({ message: "Faltan datos obligatorios" });
    }

    const [servRows] = await pool.query(
      "SELECT duracion FROM servicio WHERE id = ?",
      [id_servicio]
    );
    if (!servRows.length) return res.status(400).json({ message: "Servicio no encontrado" });
    const duracionMin = parseInt(servRows[0].duracion, 10);

    const hora_fin = addMinutesToTime(hora_inicio, duracionMin);

    const [result] = await pool.query(
      `INSERT INTO citas (fecha, hora_inicio, hora_finalizacion, id_usuario, id_mascota, id_veterinario_o_zootecnista, id_servicio, id_estado_cita)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [fecha, hora_inicio, hora_fin, id_usuario, id_mascota || null, id_veterinario, id_servicio, 3]
    );

    res.status(201).json({ message: "Cita creada correctamente", id: result.insertId });
  } catch (error) {
    console.error("❌ Error crear cita:", error);
    res.status(500).json({ message: "Error al crear la cita" });
  }
};
