import { pool } from "../../utils/db.js";

/**
 * Obtiene las citas básicas de un veterinario
 */
export const getCitasBasicasVeterinario = async (req, res) => {
  const { idVet } = req.params;

  try {
    const [rows] = await pool.query(
      `SELECT c.id,
              m.nombre AS nombreMascota,
              c.fecha,
              c.hora_inicio,
              c.hora_finalizacion,
              s.nombre AS servicio,
              m.foto,
              c.id_estado_cita
       FROM citas c
       JOIN mascota m ON c.id_mascota = m.id
       JOIN servicio s ON c.id_servicio = s.id
       WHERE c.id_veterinario_o_zootecnista = ?`,
      [idVet]
    );

    res.json(rows);
  } catch (error) {
    console.error("❌ Error al obtener citas básicas:", error);
    res.status(500).json({ message: "Error en el servidor" });
  }
};

/**
 * Actualiza el estado de una cita
 * - 2 → Completada
 * - 3 → Cancelada
 */
export const actualizarEstadoCita = async (req, res) => {
  const { id } = req.params;
  const { estado } = req.body; // puede venir como número o texto

  let estadoId;

  if (estado === 2 || estado === "Completada") estadoId = 2;
  else if (estado === 3 || estado === "Cancelada") estadoId = 3;
  else {
    return res.status(400).json({ message: "Estado inválido" });
  }

  try {
    await pool.query(
      "UPDATE citas SET id_estado_cita = ? WHERE id = ?",
      [estadoId, id]
    );

    res.json({ message: "✅ Estado de la cita actualizado correctamente" });
  } catch (error) {
    console.error("❌ Error actualizando estado:", error);
    res.status(500).json({ message: "Error en el servidor" });
  }
};
