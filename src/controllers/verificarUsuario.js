import {pool} from '../../utils/db.js';

export const verificarUsuario = async (req, res) => {
  const { id, correo_electronico } = req.body;

  try {
    // Verificar en la tabla de usuarios
    const [userResult] = await pool.query(
      'SELECT * FROM usuario WHERE id = ? OR correo_electronico = ?',
      [id, correo_electronico]
    );

    if (userResult.length > 0) {
      const userExists = userResult[0];
      if (userExists.id === id) {
        return res.json({ exists: true, message: 'La identificación ya está registrada.' });
      }
      if (userExists.correo_electronico === correo_electronico) {
        return res.json({ exists: true, message: 'El correo electrónico ya está en uso.' });
      }
    }

    // Verificar en la tabla de veterinarios
    const [vetResult] = await pool.query(
      'SELECT * FROM veterinario_o_zootecnista WHERE id = ? OR correo_electronico = ?',
      [id, correo_electronico]
    );

    if (vetResult.length > 0) {
      const vetExists = vetResult[0];
      if (vetExists.id === id) {
        return res.json({ exists: true, message: 'La identificación ya está registrada.' });
      }
      if (vetExists.correo_electronico === correo_electronico) {
        return res.json({ exists: true, message: 'El correo electrónico ya está en uso.' });
      }
    }

    // Si no se encuentra en ninguna tabla
    res.json({ exists: false });
  } catch (error) {
    console.error('Error al verificar usuario:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
};
