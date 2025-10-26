import { pool } from '../../utils/db.js';

/* =========================================================
   OBTENER TODOS LOS VETERINARIOS
   ========================================================= */
export const getVeterinarios = async (req, res) => {
  try {
    const query = `
      SELECT 
        v.id,
        v.primer_nombre,
        v.segundo_nombre,
        v.primer_apellido,
        v.segundo_apellido,
        v.foto,
        v.correo_electronico,
        v.telefono,
        v.direccion_clinica,
        v.descripcion_de_perfil,
        CONCAT(v.primer_nombre, ' ', v.primer_apellido) AS nombre,
        COALESCE(ROUND(AVG(c.puntaje), 1), 0) AS promedio_calificaciones,
        COUNT(c.id) AS total_resenas
      FROM veterinario_o_zootecnista v
      LEFT JOIN calificaciones c ON v.id = c.id_veterinario_o_zootecnista
      GROUP BY 
        v.id, 
        v.primer_nombre, 
        v.segundo_nombre, 
        v.primer_apellido, 
        v.segundo_apellido, 
        v.foto, 
        v.correo_electronico, 
        v.telefono, 
        v.direccion_clinica, 
        v.descripcion_de_perfil
      ORDER BY promedio_calificaciones DESC, total_resenas DESC
    `;

    const [rows] = await pool.query(query);

    const veterinarios = rows.map(vet => ({
      id: vet.id, 
      nombre: vet.nombre,
      primer_nombre: vet.primer_nombre,
      segundo_nombre: vet.segundo_nombre || '',
      primer_apellido: vet.primer_apellido,
      segundo_apellido: vet.segundo_apellido || '',
      foto: vet.foto || '',
      correo_electronico: vet.correo_electronico,
      telefono: vet.telefono,
      direccion_clinica: vet.direccion_clinica,
      descripcion_de_perfil: vet.descripcion_de_perfil || '',
      promedio_calificaciones: parseFloat(vet.promedio_calificaciones).toFixed(1),
      total_resenas: parseInt(vet.total_resenas)
    }));

    res.json(veterinarios);
  } catch (error) {
    console.error('Error al obtener veterinarios:', error);
    res.status(500).json({ error: 'Error al obtener los veterinarios' });
  }
};

/* =========================================================
   BUSCAR VETERINARIOS POR NOMBRE
   ========================================================= */
export const buscarVeterinarios = async (req, res) => {
  try {
    const { query } = req.query;

    if (!query || query.trim() === '') {
      return res.json([]);
    }

    const sqlQuery = `
      SELECT 
        v.id,
        v.primer_nombre,
        v.segundo_nombre,
        v.primer_apellido,
        v.segundo_apellido,
        v.foto,
        v.correo_electronico,
        v.telefono,
        v.direccion_clinica,
        v.descripcion_de_perfil,
        CONCAT(v.primer_nombre, ' ', v.primer_apellido) AS nombre,
        COALESCE(ROUND(AVG(c.puntaje), 1), 0) AS promedio_calificaciones,
        COUNT(c.id) AS total_resenas
      FROM veterinario_o_zootecnista v
      LEFT JOIN calificaciones c ON v.id = c.id_veterinario_o_zootecnista
      WHERE 
        LOWER(CONCAT(v.primer_nombre, ' ', v.primer_apellido)) LIKE LOWER(?) OR
        LOWER(CONCAT(v.primer_nombre, ' ', COALESCE(v.segundo_nombre, ''), ' ', v.primer_apellido, ' ', COALESCE(v.segundo_apellido, ''))) LIKE LOWER(?) OR
        LOWER(v.primer_nombre) LIKE LOWER(?) OR
        LOWER(v.primer_apellido) LIKE LOWER(?)
      GROUP BY 
        v.id, 
        v.primer_nombre, 
        v.segundo_nombre, 
        v.primer_apellido, 
        v.segundo_apellido, 
        v.foto, 
        v.correo_electronico, 
        v.telefono, 
        v.direccion_clinica, 
        v.descripcion_de_perfil
      ORDER BY promedio_calificaciones DESC, total_resenas DESC
    `;

    const likeQuery = `%${query}%`;
    const [rows] = await pool.query(sqlQuery, [likeQuery, likeQuery, likeQuery, likeQuery]);

    const veterinarios = rows.map(vet => ({
      id: vet.id, // 👈 corregido aquí
      nombre: vet.nombre,
      primer_nombre: vet.primer_nombre,
      segundo_nombre: vet.segundo_nombre || '',
      primer_apellido: vet.primer_apellido,
      segundo_apellido: vet.segundo_apellido || '',
      foto: vet.foto || '',
      correo_electronico: vet.correo_electronico,
      telefono: vet.telefono,
      direccion_clinica: vet.direccion_clinica,
      descripcion_de_perfil: vet.descripcion_de_perfil || '',
      promedio_calificaciones: parseFloat(vet.promedio_calificaciones).toFixed(1),
      total_resenas: parseInt(vet.total_resenas)
    }));

    res.json(veterinarios);
  } catch (error) {
    console.error('Error al buscar veterinarios:', error);
    res.status(500).json({ error: 'Error al buscar veterinarios' });
  }
};

/* =========================================================
   OBTENER DETALLE DE VETERINARIO (info + horarios + servicios)
   ========================================================= */
export const getVeterinarioDetalle = async (req, res) => {
  const { id } = req.params;
  try {
    // 🟢 Información básica del veterinario
    const [vetRows] = await pool.query(
      `SELECT 
          id, 
          CONCAT(primer_nombre, ' ', primer_apellido) AS nombre, 
          foto, 
          descripcion_de_perfil
       FROM veterinario_o_zootecnista 
       WHERE id = ?`,
      [id]
    );

    if (!vetRows.length)
      return res.status(404).json({ message: "Veterinario no encontrado" });

    const vet = vetRows[0];

    // 🕓 Horarios del veterinario (si existe la tabla)
    let horarios = [];
    try {
      const [rows] = await pool.query(
        `SELECT dia_semana, hora_inicio, hora_fin
         FROM horarios_veterinario
         WHERE id_veterinario = ?
         ORDER BY dia_semana, hora_inicio`,
        [id]
      );
      horarios = rows;
    } catch {
      console.warn("⚠️ Tabla horarios_veterinario no existe, se omite.");
    }

    // 💼 Servicios que ofrece (con su precio personalizado)
    const [servicios] = await pool.query(
      `SELECT 
          s.id AS id_servicio,
          s.nombre,
          s.duracion,
          pvs.precio AS precio_veterinario
       FROM p_veterinario_servicio pvs
       INNER JOIN servicio s ON pvs.id_servicio = s.id
       WHERE pvs.id_veterinario_o_zootecnista = ?`,
      [id]
    );

    // 📦 Respuesta final
    res.json({ vet, horarios, servicios });
  } catch (error) {
    console.error("Error al obtener detalle del veterinario:", error);
    res
      .status(500)
      .json({ error: "Error al obtener detalle del veterinario" });
  }
};

/* =========================================================
   OBTENER CITAS POR DÍA
   ========================================================= */
export const getCitasDia = async (req, res) => {
  const { id } = req.params;
  const { fecha } = req.query;

  try {
    const [rows] = await pool.query(
      `SELECT hora_inicio, hora_fin
       FROM citas
       WHERE id_veterinario = ? AND fecha = ? AND estado IN ('confirmada', 'pendiente')`,
      [id, fecha]
    );

    res.json(rows);
  } catch (error) {
    console.error('Error al obtener citas:', error);
    res.status(500).json({ error: 'Error al obtener citas del día' });
  }
};
