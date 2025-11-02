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
        COUNT(c.id) AS total_resenas,
        GROUP_CONCAT(DISTINCT s.nombre SEPARATOR ', ') AS servicios_ofrecidos
      FROM veterinario_o_zootecnista v
      LEFT JOIN calificaciones c ON v.id = c.id_veterinario_o_zootecnista
      LEFT JOIN p_veterinario_servicio pvs ON v.id = pvs.id_veterinario_o_zootecnista
      LEFT JOIN servicio s ON pvs.id_servicio = s.id
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
      total_resenas: parseInt(vet.total_resenas),
      servicios_ofrecidos: vet.servicios_ofrecidos || ''
    }));

    res.json(veterinarios);
  } catch (error) {
    console.error('Error al obtener veterinarios:', error);
    res.status(500).json({ error: 'Error al obtener los veterinarios', message: error.message });
  }
};

/* =========================================================
   BUSCAR VETERINARIOS POR NOMBRE, SERVICIO O ESPECIALIDAD
   ========================================================= */
export const buscarVeterinarios = async (req, res) => {
  try {
    const { query } = req.query;

    if (!query || query.trim() === '') {
      return res.json([]);
    }

    const sqlQuery = `
      SELECT DISTINCT
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
        COUNT(c.id) AS total_resenas,
        GROUP_CONCAT(DISTINCT s.nombre SEPARATOR ', ') AS servicios_ofrecidos
      FROM veterinario_o_zootecnista v
      LEFT JOIN calificaciones c ON v.id = c.id_veterinario_o_zootecnista
      LEFT JOIN p_veterinario_servicio pvs ON v.id = pvs.id_veterinario_o_zootecnista
      LEFT JOIN servicio s ON pvs.id_servicio = s.id
      LEFT JOIN p_veterinario_o_zootecnista_especializaciones pve ON v.id = pve.id_veterinario_o_zootecnista
      LEFT JOIN especializaciones e ON pve.id_especializaciones = e.id
      WHERE
        LOWER(CONCAT(v.primer_nombre, ' ', v.primer_apellido)) LIKE LOWER(?) OR
        LOWER(CONCAT(v.primer_nombre, ' ', COALESCE(v.segundo_nombre, ''), ' ', v.primer_apellido, ' ', COALESCE(v.segundo_apellido, ''))) LIKE LOWER(?) OR
        LOWER(v.primer_nombre) LIKE LOWER(?) OR
        LOWER(v.primer_apellido) LIKE LOWER(?) OR
        LOWER(s.nombre) LIKE LOWER(?) OR
        LOWER(e.nombre) LIKE LOWER(?)
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
    const [rows] = await pool.query(sqlQuery, [likeQuery, likeQuery, likeQuery, likeQuery, likeQuery, likeQuery]);

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
      total_resenas: parseInt(vet.total_resenas),
      servicios_ofrecidos: vet.servicios_ofrecidos || ''
    }));

    res.json(veterinarios);
  } catch (error) {
    console.error('Error al buscar veterinarios:', error);
    res.status(500).json({ error: 'Error al buscar veterinarios', message: error.message });
  }
};

/* =========================================================
   OBTENER DETALLE DE VETERINARIO (info + horarios + servicios)
   ========================================================= */
// getVeterinarioDetalle (mejorado)
export const getVeterinarioDetalle = async (req, res) => {
  const { id } = req.params;
  try {
    // Vet básico con promedio de calificaciones
    const [vetRows] = await pool.query(
      `SELECT v.id, v.primer_nombre, v.segundo_nombre, v.primer_apellido, v.segundo_apellido, v.correo_electronico, v.telefono, CONCAT(v.primer_nombre, ' ', v.primer_apellido) AS nombre, v.foto, v.descripcion_de_perfil, COALESCE(ROUND(AVG(c.puntaje), 1), 0) AS promedio_calificaciones
       FROM veterinario_o_zootecnista v
       LEFT JOIN calificaciones c ON v.id = c.id_veterinario_o_zootecnista
       WHERE v.id = ?
       GROUP BY v.id, v.primer_nombre, v.segundo_nombre, v.primer_apellido, v.segundo_apellido, v.correo_electronico, v.telefono, v.foto, v.descripcion_de_perfil`,
      [id]
    );
    if (!vetRows.length) return res.status(404).json({ message: "Veterinario no encontrado" });
    const vet = vetRows[0];
    console.log("Fetched vet foto:", vet.foto); // Add this line

    // Especializaciones (vía tabla pivote p_veterinario_o_zootecnista_especializaciones)
    const [especializaciones] = await pool.query(
      `SELECT e.id, e.nombre
       FROM p_veterinario_o_zootecnista_especializaciones pv
       JOIN especializaciones e ON pv.id_especializaciones = e.id
       WHERE pv.id_veterinario_o_zootecnista = ?`,
      [id]
    );
    console.log("Fetched especializaciones:", especializaciones); // Add this line

    // Horarios (tabla horarios) — devuelve filas con dia_semana, hora_inicio, hora_finalizacion
    let horarios = [];
    try {
      const [horRows] = await pool.query(
        `SELECT dia_semana, hora_inicio, hora_finalizacion
         FROM horarios
         WHERE id_veterinario_o_zootecnista = ?
         ORDER BY FIELD(dia_semana, 'Lunes','Martes','Miércoles','Jueves','Viernes','Sábado','Domingo'), hora_inicio`,
        [id]
      );
      horarios = horRows;
    } catch (err) {
      console.warn('Tabla horarios no disponible o error:', err.message);
    }

    // Servicios (pivot p_veterinario_servicio -> servicio)
    const [servicios] = await pool.query(
      `SELECT s.id, s.nombre, s.duracion, COALESCE(pvs.precio, s.precio) AS precio
       FROM p_veterinario_servicio pvs
       JOIN servicio s ON pvs.id_servicio = s.id
       WHERE pvs.id_veterinario_o_zootecnista = ?`,
      [id]
    );

    res.json({ vet, especializaciones, horarios, servicios });
  } catch (error) {
    console.error("Error al obtener detalle del veterinario:", error);
    res.status(500).json({ error: "Error al obtener detalle del veterinario", message: error.message });
  }
};


/* =========================================================
   ACTUALIZAR PERFIL DE VETERINARIO
   ========================================================= */
export const updateVeterinarioProfile = async (req, res) => {
  const { id } = req.params;
  const {
    primer_nombre,
    segundo_nombre,
    primer_apellido,
    segundo_apellido,
    correo_electronico,
    telefono,
    especializacion,
    informacion,
    foto,
    servicios,
  } = req.body;

  try {
    // Actualizar datos básicos del veterinario
    await pool.query(
      `UPDATE veterinario_o_zootecnista
       SET primer_nombre = ?, segundo_nombre = ?, primer_apellido = ?, segundo_apellido = ?, correo_electronico = ?, telefono = ?, descripcion_de_perfil = ?, foto = ?
       WHERE id = ?`,
      [primer_nombre, segundo_nombre || null, primer_apellido, segundo_apellido || null, correo_electronico, telefono, informacion, foto, id]
    );

    // Actualizar especialización (asumiendo que solo hay una o se actualiza la principal)
    if (especializacion) {
      // Primero, eliminar especializaciones existentes para este veterinario
      await pool.query(
        "DELETE FROM p_veterinario_o_zootecnista_especializaciones WHERE id_veterinario_o_zootecnista = ?",
        [id]
      );
      // Luego, insertar la nueva especialización
      const [espResult] = await pool.query("SELECT id FROM especializaciones WHERE nombre = ?", [especializacion]);
      if (espResult.length > 0) {
        await pool.query(
          "INSERT INTO p_veterinario_o_zootecnista_especializaciones (id_veterinario_o_zootecnista, id_especializaciones) VALUES (?, ?)",
          [id, espResult[0].id]
        );
      }
    }

    // Actualizar servicios (eliminar existentes y insertar nuevos con precios)
    if (servicios && Array.isArray(servicios)) {
      // Primero, eliminar servicios existentes para este veterinario
      await pool.query(
        "DELETE FROM p_veterinario_servicio WHERE id_veterinario_o_zootecnista = ?",
        [id]
      );
      // Luego, insertar los nuevos servicios con sus precios
      for (const servicio of servicios) {
        const precio = parseFloat(servicio.precio) || 0;
        await pool.query(
          "INSERT INTO p_veterinario_servicio (id_veterinario_o_zootecnista, id_servicio, precio) VALUES (?, ?, ?)",
          [id, servicio.id, precio]
        );
      }
    }

    res.status(200).json({ message: "Perfil actualizado correctamente." });
  } catch (error) {
    console.error("Error al actualizar perfil de veterinario:", error);
    res.status(500).json({ error: "Error al actualizar perfil de veterinario", message: error.message });
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
    res.status(500).json({ error: 'Error al obtener citas del día', message: error.message });
  }
};
