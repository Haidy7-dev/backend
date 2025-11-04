import { pool } from "../../utils/db.js";

function addMinutesToTime(timeStr, minutes) {
  const [hh, mm, ss] = timeStr.split(":").map((n) => parseInt(n, 10));
  const totalMin = hh * 60 + mm + minutes;
  const newH = Math.floor((totalMin % (24 * 60)) / 60);
  const newM = totalMin % 60;
  return `${String(newH).padStart(2, "0")}:${String(newM).padStart(2, "0")}:00`;
}

export const CreateCita = async (req, res) => {
  const connection = await pool.getConnection();
  try {
    await connection.beginTransaction();

    const {
      fecha,
      hora_inicio,
      id_veterinario,
      id_servicio,
      id_usuario,
      id_mascota,
      modalidad,
    } = req.body;

    if (!fecha || !hora_inicio || !id_veterinario || !id_servicio || !id_usuario || !modalidad) {
      return res.status(400).json({ message: "Faltan datos obligatorios" });
    }

    const hora_inicio_corregida = hora_inicio.length === 5 ? `${hora_inicio}:00` : hora_inicio;

    const [servRows] = await connection.query(
      "SELECT duracion, precio FROM servicio WHERE id = ?",
      [id_servicio]
    );
    if (!servRows.length) {
      await connection.rollback();
      return res.status(400).json({ message: "Servicio no encontrado" });
    }
    
    const duracionMin = parseInt(servRows[0].duracion, 10);
    const precioServicio = parseFloat(servRows[0].precio);

    const hora_finalizacion = addMinutesToTime(hora_inicio_corregida, duracionMin);
    
    const iva = 19;
    const total = precioServicio * (1 + iva / 100);

    const [resultCita] = await connection.query(
      `INSERT INTO citas (fecha, hora_inicio, hora_finalizacion, id_usuario, id_mascota, id_veterinario_o_zootecnista, id_servicio, id_estado_cita)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [fecha, hora_inicio_corregida, hora_finalizacion, id_usuario, id_mascota || null, id_veterinario, id_servicio, 1]
    );

    const idCita = resultCita.insertId;

    console.log('Inserting into resumen_citas:', { idCita, modalidad, hora_inicio: hora_inicio_corregida, hora_finalizacion, iva, total });

    await connection.query(
      `INSERT INTO resumen_citas (id_cita, modalidad, hora_inicio, hora_finalizacion, iva, total)
       VALUES (?, ?, ?, ?, ?, ?)`,

      [idCita, modalidad, hora_inicio_corregida, hora_finalizacion, iva, total]
    );

        await connection.commit();

        res.status(201).json({ message: "Cita creada correctamente", id: idCita });

  } catch (error) {
    await connection.rollback();
    console.error("❌ Error crear cita:", error);
    res.status(500).json({ message: "Error al crear la cita", error: error.message });
  } finally {
    connection.release();
  }
};

