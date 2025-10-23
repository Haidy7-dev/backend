import pool from '../db.js'; // Asegúrate que tu archivo db también use export

// Obtener todos los veterinarios con calificaciones calculadas dinámicamente
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
        CONCAT(v.primer_nombre, ' ', v.primer_apellido) as nombre,
        COALESCE(ROUND(AVG(c.puntaje)::numeric, 1), 0) as promedio_calificaciones,
        COUNT(c.id) as total_resenas
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
    
    const result = await pool.query(query);
    
    // Formatear los datos
    const veterinarios = result.rows.map(vet => ({
      id_veterinario: vet.id,
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

// Buscar veterinarios por nombre
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
        CONCAT(v.primer_nombre, ' ', v.primer_apellido) as nombre,
        COALESCE(ROUND(AVG(c.puntaje)::numeric, 1), 0) as promedio_calificaciones,
        COUNT(c.id) as total_resenas
      FROM veterinario_o_zootecnista v
      LEFT JOIN calificaciones c ON v.id = c.id_veterinario_o_zootecnista
      WHERE 
        LOWER(CONCAT(v.primer_nombre, ' ', v.primer_apellido)) LIKE LOWER($1) OR
        LOWER(CONCAT(v.primer_nombre, ' ', COALESCE(v.segundo_nombre, ''), ' ', v.primer_apellido, ' ', COALESCE(v.segundo_apellido, ''))) LIKE LOWER($1) OR
        LOWER(v.primer_nombre) LIKE LOWER($1) OR
        LOWER(v.primer_apellido) LIKE LOWER($1)
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
    
    const result = await pool.query(sqlQuery, [`%${query}%`]);
    
    const veterinarios = result.rows.map(vet => ({
      id_veterinario: vet.id,
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