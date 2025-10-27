import { pool } from '../../utils/db.js';

function addMinutesToTime(timeStr, minutes) {
  // timeStr 'HH:MM:SS' o 'HH:MM'
  const [hh, mm, ss] = timeStr.split(':').map(n => parseInt(n, 10));
  const totalMin = hh * 60 + mm + minutes;
  const newH = Math.floor((totalMin % (24 * 60)) / 60);
  const newM = totalMin % 60;
  return `${String(newH).padStart(2,'0')}:${String(newM).padStart(2,'0')}:00`;
}

export const CreateCita = async (req, res) => {
  try {
    const {
      fecha,             // 'YYYY-MM-DD'
      hora_inicio,       // 'HH:MM' o 'HH:MM:SS'
      id_veterinario,    // id veterinario (varchar)
      id_servicio,       // id servicio (number)
      id_usuario,        // id usuario (varchar) -> debes proveerlo desde frontend (auth)
      id_mascota         // id mascota (number) -> opcional según tu caso
    } = req.body;

    if (!fecha || !hora_inicio || !id_veterinario || !id_servicio || !id_usuario) {
      return res.status(400).json({ message: "Faltan datos obligatorios" });
    }

    // 1) obtener duración del servicio
    const [servRows] = await pool.query('SELECT duracion FROM servicio WHERE id = ?', [id_servicio]);
    if (!servRows.length) return res.status(400).json({ message: "Servicio no encontrado" });
    const duracionMin = parseInt(servRows[0].duracion, 10);

    // 2) calcular hora_finalizacion
    const hora_fin = addMinutesToTime(hora_inicio, duracionMin);

    // 3) insertar la cita
    // Si tu columna de estado se llama 'estado_citas' o 'id_estado_cita' que es 3 = 'Pendiente'
    const [result] = await pool.query(
      `INSERT INTO citas (fecha, hora_inicio, hora_finalizacion, id_usuario, id_mascota, id_veterinario_o_zootecnista, id_servicio, estado_citas)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [fecha, hora_inicio, hora_fin, id_usuario, id_mascota || null, id_veterinario, id_servicio, 3]
    );

    res.status(201).json({ message: "Cita creada", id: result.insertId });
  } catch (error) {
    console.error('Error crear cita:', error);
    res.status(500).json({ message: "Error al crear la cita" });
  }
};
