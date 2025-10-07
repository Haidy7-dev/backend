CREATE DATABASE  IF NOT EXISTS `patassinbarreras` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `patassinbarreras`;
-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: patassinbarreras
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auditoria`
--

DROP TABLE IF EXISTS `auditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria` (
  `id_transaccion` mediumint NOT NULL AUTO_INCREMENT,
  `transaccion` enum('I','U','D') NOT NULL DEFAULT 'U',
  `fechahora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario` varchar(15) NOT NULL,
  `tabla` varchar(50) NOT NULL,
  `campo` varchar(25) NOT NULL,
  `valor_anterior` varchar(200) DEFAULT NULL,
  `valor_nuevo` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id_transaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria`
--

LOCK TABLES `auditoria` WRITE;
/*!40000 ALTER TABLE `auditoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `calificaciones`
--

DROP TABLE IF EXISTS `calificaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `calificaciones` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `puntaje` int DEFAULT NULL,
  `creado_en` timestamp NULL DEFAULT NULL,
  `id_veterinario_o_zootecnista` varchar(10) NOT NULL,
  `id_usuario` varchar(10) NOT NULL,
  `id_servicio` mediumint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_veterinario_o_zootecnista` (`id_veterinario_o_zootecnista`),
  KEY `fk_usuar` (`id_usuario`),
  KEY `fk_servic` (`id_servicio`),
  CONSTRAINT `fk_servic` FOREIGN KEY (`id_servicio`) REFERENCES `servicio` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_usuar` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_veterinario_o_zootecnista` FOREIGN KEY (`id_veterinario_o_zootecnista`) REFERENCES `veterinario_o_zootecnista` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calificaciones`
--

LOCK TABLES `calificaciones` WRITE;
/*!40000 ALTER TABLE `calificaciones` DISABLE KEYS */;
INSERT INTO `calificaciones` (`id`, `puntaje`, `creado_en`, `id_veterinario_o_zootecnista`, `id_usuario`, `id_servicio`) VALUES (1,5,'2025-01-01 16:00:00','1102632848','1052795396',3);
INSERT INTO `calificaciones` (`id`, `puntaje`, `creado_en`, `id_veterinario_o_zootecnista`, `id_usuario`, `id_servicio`) VALUES (2,4,'2025-01-02 17:00:00','1004633134','1053796646',2);
INSERT INTO `calificaciones` (`id`, `puntaje`, `creado_en`, `id_veterinario_o_zootecnista`, `id_usuario`, `id_servicio`) VALUES (3,4,'2025-01-02 18:00:00','1004634002','1050797430',1);
INSERT INTO `calificaciones` (`id`, `puntaje`, `creado_en`, `id_veterinario_o_zootecnista`, `id_usuario`, `id_servicio`) VALUES (4,5,'2025-01-02 19:00:00','1002234684','1051801555',4);
/*!40000 ALTER TABLE `calificaciones` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `calificaciones_AFTER_INSERT` AFTER INSERT ON `calificaciones` FOR EACH ROW BEGIN
	INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
		VALUES('I',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'calificaciones','id',NULL,NEW.ID);
        
	INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
		VALUES('I',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'calificaciones','puntaje',NULL,NEW.puntaje);
        
	INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
		VALUES('I',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'calificaciones','creado_en',NULL,NEW.creado_en);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `calificaciones_AFTER_UPDATE` AFTER UPDATE ON `calificaciones` FOR EACH ROW BEGIN
	IF (OLD.ID != NEW.ID) THEN
		INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
			VALUES('U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'calificaciones',
				   'Id',OLD.ID,NEW.ID);    
	END IF;
 
 	IF (OLD.puntaje <> NEW.puntaje) THEN
        INSERT INTO auditoria (transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
        VALUES ('U', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'calificaciones',
                'puntaje', OLD.puntaje, NEW.puntaje);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `calificaciones_AFTER_DELETE` AFTER DELETE ON `calificaciones` FOR EACH ROW BEGIN
    INSERT INTO auditoria (transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES ('D', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'calificaciones',
            'id', OLD.id, NULL);
    
    INSERT INTO auditoria (transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES ('D', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'calificaciones',
            'puntaje', OLD.puntaje, NULL);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `citas`
--

DROP TABLE IF EXISTS `citas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `citas` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_finalizacion` time NOT NULL,
  `id_usuario` varchar(10) NOT NULL,
  `id_mascota` mediumint unsigned NOT NULL,
  `id_veterinario_o_zootecnista` varchar(10) NOT NULL,
  `id_servicio` mediumint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cita_usuario` (`id_usuario`),
  KEY `fk_cita_mascota` (`id_mascota`),
  KEY `fk_cita_veterinario` (`id_veterinario_o_zootecnista`),
  KEY `fk_cita_servicio` (`id_servicio`),
  CONSTRAINT `fk_cita_mascota` FOREIGN KEY (`id_mascota`) REFERENCES `mascota` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_cita_servicio` FOREIGN KEY (`id_servicio`) REFERENCES `servicio` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_cita_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_cita_veterinario` FOREIGN KEY (`id_veterinario_o_zootecnista`) REFERENCES `veterinario_o_zootecnista` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citas`
--

LOCK TABLES `citas` WRITE;
/*!40000 ALTER TABLE `citas` DISABLE KEYS */;
/*!40000 ALTER TABLE `citas` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `citas_AFTER_INSERT` AFTER INSERT ON `citas` FOR EACH ROW BEGIN
	INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
		VALUES('I',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'citas','id',NULL,NEW.ID);
	
    INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES (NULL, 'I', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'citas',
            'fecha', NULL, NEW.fecha);

    INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES (NULL, 'I', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'citas',
            'hora_inicio', NULL, NEW.hora_inicio);

    INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES (NULL, 'I', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'citas',
            'hora_finalizacion', NULL, NEW.hora_finalizacion);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `citas_AFTER_UPDATE` AFTER UPDATE ON `citas` FOR EACH ROW BEGIN
	IF (OLD.id <> NEW.id) THEN
        INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
        VALUES (NULL, 'U', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'citas',
                'id', OLD.id, NEW.id);
    END IF;
    
    IF (OLD.fecha <> NEW.fecha) THEN
        INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
        VALUES (NULL, 'U', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'citas',
                'fecha', OLD.fecha, NEW.fecha);
    END IF;

    IF (OLD.hora_inicio <> NEW.hora_inicio) THEN
        INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
        VALUES (NULL, 'U', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'citas',
                'hora_inicio', OLD.hora_inicio, NEW.hora_inicio);
    END IF;

    IF (OLD.hora_finalizacion <> NEW.hora_finalizacion) THEN
        INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
        VALUES (NULL, 'U', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'citas',
                'hora_finalizacion', OLD.hora_finalizacion, NEW.hora_finalizacion);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `citas_AFTER_DELETE` AFTER DELETE ON `citas` FOR EACH ROW BEGIN
    INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES (NULL, 'D', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'citas',
            'id', OLD.id, NULL);	
    
    INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES (NULL, 'D', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'citas',
            'fecha', OLD.fecha, NULL);

    -- Auditoría de eliminación de hora_inicio
    INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES (NULL, 'D', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'citas',
            'hora_inicio', OLD.hora_inicio, NULL);

    -- Auditoría de eliminación de hora_finalizacion
    INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES (NULL, 'D', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'citas',
            'hora_finalizacion', OLD.hora_finalizacion, NULL);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `especializaciones`
--

DROP TABLE IF EXISTS `especializaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `especializaciones` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `especializaciones`
--

LOCK TABLES `especializaciones` WRITE;
/*!40000 ALTER TABLE `especializaciones` DISABLE KEYS */;
INSERT INTO `especializaciones` (`id`, `nombre`) VALUES (1,'Médico General');
INSERT INTO `especializaciones` (`id`, `nombre`) VALUES (2,'Cardiología');
INSERT INTO `especializaciones` (`id`, `nombre`) VALUES (3,'Ciguría');
INSERT INTO `especializaciones` (`id`, `nombre`) VALUES (4,'Fisioterapia');
/*!40000 ALTER TABLE `especializaciones` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `especializaciones_BEFORE_INSERT` BEFORE INSERT ON `especializaciones` FOR EACH ROW BEGIN
    DECLARE existe INT;

    -- Verificar si ya existe una especialización con el mismo nombre
    SELECT COUNT(*) INTO existe
    FROM especializaciones
    WHERE nombre = NEW.nombre;

    IF existe > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Ya existe una especialización con este nombre';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `especializaciones_AFTER_INSERT` AFTER INSERT ON `especializaciones` FOR EACH ROW BEGIN
	INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
		VALUES('I',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'especializaciones','id',NULL,NEW.ID);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `especializaciones_AFTER_UPDATE` AFTER UPDATE ON `especializaciones` FOR EACH ROW BEGIN
	IF (OLD.ID != NEW.ID) THEN
		INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
			VALUES('U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'especializaciones',
				   'Id',OLD.ID,NEW.ID);    
	END IF;
 
 	IF (OLD.NOMBRE != NEW.NOMBRE) THEN
		INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
			VALUES('U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'especializaciones',
				   'Nombre',OLD.NOMBRE,NEW.NOMBRE);    
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `especializaciones_AFTER_DELETE` AFTER DELETE ON `especializaciones` FOR EACH ROW BEGIN
	INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
		VALUES('D',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'especializaciones',
			   'Id',CONCAT(OLD.ID,' ',OLD.NOMBRE),NULL);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `especie`
--

DROP TABLE IF EXISTS `especie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `especie` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) NOT NULL,
  `tipo_cubierta_corp` varchar(30) NOT NULL,
  `longevidad` varchar(10) NOT NULL,
  `origen_geografico` varchar(50) NOT NULL,
  `habitat` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `especie`
--

LOCK TABLES `especie` WRITE;
/*!40000 ALTER TABLE `especie` DISABLE KEYS */;
INSERT INTO `especie` (`id`, `nombre`, `tipo_cubierta_corp`, `longevidad`, `origen_geografico`, `habitat`) VALUES (1,'Canis','Pelo','10 a 13','Europa','Terrestre');
INSERT INTO `especie` (`id`, `nombre`, `tipo_cubierta_corp`, `longevidad`, `origen_geografico`, `habitat`) VALUES (2,'Felis','Pelo','12 a 18','Asia','Terrestre');
INSERT INTO `especie` (`id`, `nombre`, `tipo_cubierta_corp`, `longevidad`, `origen_geografico`, `habitat`) VALUES (3,'Bovino','Pelo','20 a 25','América','Terrestre');
INSERT INTO `especie` (`id`, `nombre`, `tipo_cubierta_corp`, `longevidad`, `origen_geografico`, `habitat`) VALUES (4,'Equino','Pelo','25 a 30','Europa','Terrestre');
/*!40000 ALTER TABLE `especie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horarios`
--

DROP TABLE IF EXISTS `horarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horarios` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `dia_semana` enum('Lunes','Martes','Miércoles','Jueves','Viernes','Sábado','Domingo') NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_finalizacion` time NOT NULL,
  `id_veterinario_o_zootecnista` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_horario_veterinario` (`id_veterinario_o_zootecnista`),
  CONSTRAINT `fk_horario_veterinario` FOREIGN KEY (`id_veterinario_o_zootecnista`) REFERENCES `veterinario_o_zootecnista` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horarios`
--

LOCK TABLES `horarios` WRITE;
/*!40000 ALTER TABLE `horarios` DISABLE KEYS */;
/*!40000 ALTER TABLE `horarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `horarios_AFTER_INSERT` AFTER INSERT ON `horarios` FOR EACH ROW BEGIN
	INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES (NULL, 'I', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'horarios',
            'id', NULL, NEW.id);

    INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES (NULL, 'I', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'horarios',
            'dia_semana', NULL, NEW.dia_semana);

    INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES (NULL, 'I', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'horarios',
            'hora_inicio', NULL, NEW.hora_inicio);

    INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES (NULL, 'I', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'horarios',
            'hora_finalizacion', NULL, NEW.hora_finalizacion);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `horarios_AFTER_UPDATE` AFTER UPDATE ON `horarios` FOR EACH ROW BEGIN
	IF (OLD.dia_semana <> NEW.dia_semana) THEN
        INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
        VALUES (NULL, 'U', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'horarios',
                'dia_semana', OLD.dia_semana, NEW.dia_semana);
    END IF;

    IF (OLD.hora_inicio <> NEW.hora_inicio) THEN
        INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
        VALUES (NULL, 'U', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'horarios',
                'hora_inicio', OLD.hora_inicio, NEW.hora_inicio);
    END IF;

    IF (OLD.hora_finalizacion <> NEW.hora_finalizacion) THEN
        INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
        VALUES (NULL, 'U', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'horarios',
                'hora_finalizacion', OLD.hora_finalizacion, NEW.hora_finalizacion);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `horarios_AFTER_DELETE` AFTER DELETE ON `horarios` FOR EACH ROW BEGIN
	INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES (NULL, 'D', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'horarios',
            'id', OLD.id, NULL);

    INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES (NULL, 'D', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'horarios',
            'dia_semana', OLD.dia_semana, NULL);

    INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES (NULL, 'D', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'horarios',
            'hora_inicio', OLD.hora_inicio, NULL);

    INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES (NULL, 'D', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'horarios',
            'hora_finalizacion', OLD.hora_finalizacion, NULL);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `mascota`
--

DROP TABLE IF EXISTS `mascota`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mascota` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(15) NOT NULL,
  `sexo` varchar(9) NOT NULL,
  `peso` float DEFAULT NULL,
  `edad` varchar(3) DEFAULT NULL,
  `id_usuario` varchar(10) NOT NULL,
  `id_veterinario_o_zootecnista` varchar(10) DEFAULT NULL,
  `id_raza` mediumint unsigned NOT NULL,
  `id_especie` mediumint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_usuario` (`id_usuario`),
  KEY `fk_veterinario_zoot` (`id_veterinario_o_zootecnista`),
  KEY `fk_raza` (`id_raza`),
  KEY `fk_espec` (`id_especie`),
  CONSTRAINT `fk_espec` FOREIGN KEY (`id_especie`) REFERENCES `especie` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_raza` FOREIGN KEY (`id_raza`) REFERENCES `raza` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_veterinario_zoot` FOREIGN KEY (`id_veterinario_o_zootecnista`) REFERENCES `veterinario_o_zootecnista` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mascota`
--

LOCK TABLES `mascota` WRITE;
/*!40000 ALTER TABLE `mascota` DISABLE KEYS */;
INSERT INTO `mascota` (`id`, `nombre`, `sexo`, `peso`, `edad`, `id_usuario`, `id_veterinario_o_zootecnista`, `id_raza`, `id_especie`) VALUES (1,'Rex','Macho',22,'5','1052795396','1102632848',1,1);
INSERT INTO `mascota` (`id`, `nombre`, `sexo`, `peso`, `edad`, `id_usuario`, `id_veterinario_o_zootecnista`, `id_raza`, `id_especie`) VALUES (2,'Zeus','Macho',10,'6','1053796646','1004633134',2,2);
INSERT INTO `mascota` (`id`, `nombre`, `sexo`, `peso`, `edad`, `id_usuario`, `id_veterinario_o_zootecnista`, `id_raza`, `id_especie`) VALUES (3,'Thor','Macho',450,'2','1050797430','1004634002',3,3);
INSERT INTO `mascota` (`id`, `nombre`, `sexo`, `peso`, `edad`, `id_usuario`, `id_veterinario_o_zootecnista`, `id_raza`, `id_especie`) VALUES (4,'Oliver','Macho',550,'7','1051801555','1002234684',4,4);
/*!40000 ALTER TABLE `mascota` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `mascota_AFTER_INSERT` AFTER INSERT ON `mascota` FOR EACH ROW BEGIN
	-- Actualiza el número de mascotas del usuario después de insertar una mascota
    UPDATE usuario SET n_de_mascotas = (SELECT COUNT(*) FROM mascota WHERE id_usuario = NEW.id_usuario)
		WHERE id = NEW.id_usuario;
     
     -- Insertar en la tabla de auditoría
    INSERT INTO auditoria (transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES ('I', NOW(), SUBSTRING_INDEX(CURRENT_USER(), '@', 1), 'mascota', 'id', NULL, NEW.id);
    
    INSERT INTO auditoria VALUES (NULL, 'I', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'mascota',
	'nombre', NULL, NEW.nombre);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `mascota_AFTER_UPDATE` AFTER UPDATE ON `mascota` FOR EACH ROW BEGIN
	IF (OLD.nombre <> NEW.nombre) THEN
        INSERT INTO auditoria VALUES (NULL, 'U', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'mascota',
                'nombre', OLD.nombre, NEW.nombre);
    END IF;

    IF (OLD.sexo <> NEW.sexo) THEN
        INSERT INTO auditoria VALUES (NULL, 'U', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'mascota',
                'sexo', OLD.sexo, NEW.sexo);
    END IF;

    IF (OLD.peso <> NEW.peso) THEN
        INSERT INTO auditoria VALUES (NULL, 'U', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'mascota',
                'peso', OLD.peso, NEW.peso);
    END IF;

    IF (OLD.edad <> NEW.edad) THEN
        INSERT INTO auditoria VALUES (NULL, 'U', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'mascota',
                'edad', OLD.edad, NEW.edad);
    END IF;
    
    IF (OLD.ID_VETERINARIO_O_ZOOTECNISTA != NEW.ID_VETERINARIO_O_ZOOTECNISTA) THEN
		INSERT INTO auditoria (transaccion,NOMBREhora,usuario,tabla,campo,valor_anterior,valor_nuevo)
			VALUES('U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'mascota',
				   'id_veterinario_o_zootecnista',OLD.ID_VETERINARIO_O_ZOOTECNISTA,NEW.ID_VETERINARIO_O_ZOOTECNISTA);    
	END IF;
 
 	IF (OLD.ID_RAZA != NEW.ID_RAZA) THEN
		INSERT INTO auditoria (transaccion,NOMBREhora,usuario,tabla,campo,valor_anterior,valor_nuevo)
			VALUES('U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'mascota',
				   'id_raza',OLD.ID_RAZA,NEW.ID_RAZA);    
	END IF;    
 
 	IF (OLD.ID_ESPECIE != NEW.ID_ESPECIE) THEN
		INSERT INTO auditoria (transaccion,NOMBREhora,usuario,tabla,campo,valor_anterior,valor_nuevo)
			VALUES('U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'mascota',
				   'id_especie',OLD.ID_ESPECIE,NEW.ID_ESPECIE);    
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `mascota_AFTER_DELETE` AFTER DELETE ON `mascota` FOR EACH ROW BEGIN
	-- Actualizar el número de mascotas en la tabla usuario
    UPDATE usuario
    SET n_de_mascotas = n_de_mascotas - 1
    WHERE id = OLD.id_usuario;

    -- Registrar la transacción en la tabla de auditoría
    INSERT INTO auditoria (transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES ('D', NOW(), SUBSTRING_INDEX(CURRENT_USER(), '@', 1), 'mascota',
            'Id', CONCAT(OLD.id, ' ', OLD.nombre), NULL);
	
    INSERT INTO auditoria VALUES (NULL, 'D', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'mascota',
            'nombre', OLD.nombre, NULL);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `p_usuario_servicio_mascota`
--

DROP TABLE IF EXISTS `p_usuario_servicio_mascota`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `p_usuario_servicio_mascota` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `id_usuario` varchar(10) NOT NULL,
  `id_servicio` mediumint unsigned NOT NULL,
  `id_mascota` mediumint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_usua` (`id_usuario`),
  KEY `fk_servo` (`id_servicio`),
  KEY `fk_mascot` (`id_mascota`),
  CONSTRAINT `fk_mascot` FOREIGN KEY (`id_mascota`) REFERENCES `mascota` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_servo` FOREIGN KEY (`id_servicio`) REFERENCES `servicio` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_usua` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `p_usuario_servicio_mascota`
--

LOCK TABLES `p_usuario_servicio_mascota` WRITE;
/*!40000 ALTER TABLE `p_usuario_servicio_mascota` DISABLE KEYS */;
INSERT INTO `p_usuario_servicio_mascota` (`id`, `id_usuario`, `id_servicio`, `id_mascota`) VALUES (1,'1052795396',3,1);
INSERT INTO `p_usuario_servicio_mascota` (`id`, `id_usuario`, `id_servicio`, `id_mascota`) VALUES (2,'1053796646',2,2);
INSERT INTO `p_usuario_servicio_mascota` (`id`, `id_usuario`, `id_servicio`, `id_mascota`) VALUES (3,'1050797430',1,3);
INSERT INTO `p_usuario_servicio_mascota` (`id`, `id_usuario`, `id_servicio`, `id_mascota`) VALUES (4,'1051801555',4,4);
/*!40000 ALTER TABLE `p_usuario_servicio_mascota` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `p_veterinario_o_zootecnista_especializaciones`
--

DROP TABLE IF EXISTS `p_veterinario_o_zootecnista_especializaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `p_veterinario_o_zootecnista_especializaciones` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `id_veterinario_o_zootecnista` varchar(10) NOT NULL,
  `id_especializaciones` mediumint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_vetrio_o_zoota` (`id_veterinario_o_zootecnista`),
  KEY `fk_especializacion` (`id_especializaciones`),
  CONSTRAINT `fk_especializacion` FOREIGN KEY (`id_especializaciones`) REFERENCES `especializaciones` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_vetrio_o_zoota` FOREIGN KEY (`id_veterinario_o_zootecnista`) REFERENCES `veterinario_o_zootecnista` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `p_veterinario_o_zootecnista_especializaciones`
--

LOCK TABLES `p_veterinario_o_zootecnista_especializaciones` WRITE;
/*!40000 ALTER TABLE `p_veterinario_o_zootecnista_especializaciones` DISABLE KEYS */;
INSERT INTO `p_veterinario_o_zootecnista_especializaciones` (`id`, `id_veterinario_o_zootecnista`, `id_especializaciones`) VALUES (1,'1102632848',3);
INSERT INTO `p_veterinario_o_zootecnista_especializaciones` (`id`, `id_veterinario_o_zootecnista`, `id_especializaciones`) VALUES (2,'1004633134',1);
INSERT INTO `p_veterinario_o_zootecnista_especializaciones` (`id`, `id_veterinario_o_zootecnista`, `id_especializaciones`) VALUES (3,'1004634002',1);
INSERT INTO `p_veterinario_o_zootecnista_especializaciones` (`id`, `id_veterinario_o_zootecnista`, `id_especializaciones`) VALUES (4,'1002234684',2);
/*!40000 ALTER TABLE `p_veterinario_o_zootecnista_especializaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `p_veterinario_servicio`
--

DROP TABLE IF EXISTS `p_veterinario_servicio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `p_veterinario_servicio` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `id_veterinario_o_zootecnista` varchar(10) NOT NULL,
  `id_servicio` mediumint unsigned NOT NULL,
  `precio` float NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_pivot_veterinario_serv` (`id_veterinario_o_zootecnista`),
  KEY `fk_pivot_vet_servicio` (`id_servicio`),
  CONSTRAINT `fk_pivot_vet_servicio` FOREIGN KEY (`id_servicio`) REFERENCES `servicio` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_pivot_veterinario_serv` FOREIGN KEY (`id_veterinario_o_zootecnista`) REFERENCES `veterinario_o_zootecnista` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `p_veterinario_servicio`
--

LOCK TABLES `p_veterinario_servicio` WRITE;
/*!40000 ALTER TABLE `p_veterinario_servicio` DISABLE KEYS */;
/*!40000 ALTER TABLE `p_veterinario_servicio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `raza`
--

DROP TABLE IF EXISTS `raza`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `raza` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) NOT NULL,
  `tamano` varchar(7) NOT NULL,
  `long_tipo_cubierta_corp` varchar(10) NOT NULL,
  `id_especie` mediumint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_especie` (`id_especie`),
  CONSTRAINT `fk_especie` FOREIGN KEY (`id_especie`) REFERENCES `especie` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `raza`
--

LOCK TABLES `raza` WRITE;
/*!40000 ALTER TABLE `raza` DISABLE KEYS */;
INSERT INTO `raza` (`id`, `nombre`, `tamano`, `long_tipo_cubierta_corp`, `id_especie`) VALUES (1,'Alaskan Husky','Mediano','Largo',1);
INSERT INTO `raza` (`id`, `nombre`, `tamano`, `long_tipo_cubierta_corp`, `id_especie`) VALUES (2,'Persa','Mediano','Largo',2);
INSERT INTO `raza` (`id`, `nombre`, `tamano`, `long_tipo_cubierta_corp`, `id_especie`) VALUES (3,'Wagyu','Grande','Corto',3);
INSERT INTO `raza` (`id`, `nombre`, `tamano`, `long_tipo_cubierta_corp`, `id_especie`) VALUES (4,'Trakehner','Grande','Corto',4);
/*!40000 ALTER TABLE `raza` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `raza_BEFORE_INSERT` BEFORE INSERT ON `raza` FOR EACH ROW BEGIN
    DECLARE existe INT;

    -- Verificar si ya existe una raza con el mismo nombre y especie
    SELECT COUNT(*) INTO existe
    FROM raza
    WHERE nombre = NEW.nombre
      AND id_especie = NEW.id_especie;

    IF existe > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Ya existe una raza con este nombre para la especie seleccionada';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `raza_AFTER_INSERT` AFTER INSERT ON `raza` FOR EACH ROW BEGIN
    INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES (NULL, 'I', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'raza',
            'id', NULL, NEW.id);

    INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES (NULL, 'I', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'raza',
            'nombre', NULL, NEW.nombre);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `raza_AFTER_UPDATE` AFTER UPDATE ON `raza` FOR EACH ROW BEGIN
	IF (OLD.ID != NEW.ID) THEN
		INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
			VALUES('U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'raza',
				   'Id',OLD.ID,NEW.ID);    
	END IF;
 
 	IF (OLD.nombre != NEW.nombre) THEN
		INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
			VALUES('U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'raza',
				   'Nombre',OLD.nombre,NEW.nombre);    
	END IF;
    
    IF (OLD.tamano <> NEW.tamano) THEN
        INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
        VALUES (NULL, 'U', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'raza',
                'tamano', OLD.tamano, NEW.tamano);
    END IF;

    IF (OLD.long_tipo_cubierta_corp <> NEW.long_tipo_cubierta_corp) THEN
        INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
        VALUES (NULL, 'U', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'raza',
                'long_tipo_cubierta_corp', OLD.long_tipo_cubierta_corp, NEW.long_tipo_cubierta_corp);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `raza_AFTER_DELETE` AFTER DELETE ON `raza` FOR EACH ROW BEGIN
	INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES (NULL, 'D', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'raza',
            'id', OLD.id, NULL);

    INSERT INTO auditoria (id, transaccion, fechahora, usuario, tabla, campo, valor_anterior, valor_nuevo)
    VALUES (NULL, 'D', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1), 'raza',
            'nombre', OLD.nombre, NULL);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `resumen_citas`
--

DROP TABLE IF EXISTS `resumen_citas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resumen_citas` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `modalidad` enum('Presencial') NOT NULL DEFAULT 'Presencial',
  `hora_inicio` time NOT NULL,
  `hora_finalizacion` time NOT NULL,
  `iva` int NOT NULL,
  `total` int NOT NULL,
  `id_cita` mediumint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_resumen_cita` (`id_cita`),
  CONSTRAINT `fk_resumen_cita` FOREIGN KEY (`id_cita`) REFERENCES `citas` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resumen_citas`
--

LOCK TABLES `resumen_citas` WRITE;
/*!40000 ALTER TABLE `resumen_citas` DISABLE KEYS */;
/*!40000 ALTER TABLE `resumen_citas` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `resumen_citas_BEFORE_INSERT` BEFORE INSERT ON `resumen_citas` FOR EACH ROW BEGIN
    -- Validar que hora de inicio sea menor a la de finalización
    IF NEW.hora_inicio >= NEW.hora_finalizacion THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: La hora de inicio debe ser menor a la hora de finalización';
    END IF;

    -- Validar que IVA sea entre 0 y 99
    IF NEW.iva < 0 OR NEW.iva > 99 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El IVA debe estar entre 0 y 99';
    END IF;

    -- Validar que total sea positivo
    IF NEW.total <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El total debe ser mayor que 0';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `resumen_citas_AFTER_INSERT` AFTER INSERT ON `resumen_citas` FOR EACH ROW BEGIN
	INSERT INTO auditoria VALUES (NULL,'I',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),
		'resumen_citas','id',NULL,NEW.id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `resumen_citas_BEFORE_UPDATE` BEFORE UPDATE ON `resumen_citas` FOR EACH ROW BEGIN
	-- Validar que IVA sea entre 0 y 99
    IF NEW.iva < 0 OR NEW.iva > 99 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El IVA debe estar entre 0 y 99';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `resumen_citas_AFTER_UPDATE` AFTER UPDATE ON `resumen_citas` FOR EACH ROW BEGIN
	IF (OLD.modalidad <> NEW.modalidad) THEN
        INSERT INTO auditoria VALUES (NULL,'U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'resumen_citas','modalidad',OLD.modalidad,NEW.modalidad);
    END IF;

    IF (OLD.hora_inicio <> NEW.hora_inicio) THEN
        INSERT INTO auditoria VALUES (NULL,'U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'resumen_citas','hora_inicio',OLD.hora_inicio,NEW.hora_inicio);
    END IF;

    IF (OLD.hora_finalizacion <> NEW.hora_finalizacion) THEN
        INSERT INTO auditoria VALUES (NULL,'U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'resumen_citas','hora_finalizacion',OLD.hora_finalizacion,NEW.hora_finalizacion);
    END IF;

    IF (OLD.iva <> NEW.iva) THEN
        INSERT INTO auditoria VALUES (NULL,'U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'resumen_citas','iva',OLD.iva,NEW.iva);
    END IF;

    IF (OLD.total <> NEW.total) THEN
        INSERT INTO auditoria VALUES (NULL,'U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'resumen_citas','total',OLD.total,NEW.total);
    END IF;

    IF (OLD.id_cita <> NEW.id_cita) THEN
        INSERT INTO auditoria VALUES (NULL,'U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'resumen_citas','id_cita',OLD.id_cita,NEW.id_cita);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `resumen_citas_AFTER_DELETE` AFTER DELETE ON `resumen_citas` FOR EACH ROW BEGIN
	INSERT INTO auditoria VALUES (NULL,'D',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),
		'resumen_citas','id',OLD.id,NULL);
        
	INSERT INTO auditoria VALUES (NULL,'D',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),
		'resumen_citas','id_cita',OLD.id_cita,NULL);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `servicio`
--

DROP TABLE IF EXISTS `servicio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `servicio` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `duracion` int NOT NULL,
  `precio` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicio`
--

LOCK TABLES `servicio` WRITE;
/*!40000 ALTER TABLE `servicio` DISABLE KEYS */;
INSERT INTO `servicio` (`id`, `nombre`, `duracion`, `precio`) VALUES (1,'Consulta General',20,30000);
INSERT INTO `servicio` (`id`, `nombre`, `duracion`, `precio`) VALUES (2,'Vacunación',10,20000);
INSERT INTO `servicio` (`id`, `nombre`, `duracion`, `precio`) VALUES (3,'Esterilización o castración',90,80000);
INSERT INTO `servicio` (`id`, `nombre`, `duracion`, `precio`) VALUES (4,'Revisión Cardiaca',45,200000);
/*!40000 ALTER TABLE `servicio` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `servicio_BEFORE_INSERT` BEFORE INSERT ON `servicio` FOR EACH ROW BEGIN
    DECLARE existe INT;

    -- Validar nombre duplicado
    SELECT COUNT(*) INTO existe
    FROM servicio
    WHERE nombre = NEW.nombre;

    IF existe > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Ya existe un servicio con este nombre';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `servicio_AFTER_INSERT` AFTER INSERT ON `servicio` FOR EACH ROW BEGIN
	INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
		VALUES('I',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'servicio',
			   'Id',NULL,NEW.id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `servicio_AFTER_UPDATE` AFTER UPDATE ON `servicio` FOR EACH ROW BEGIN
	IF (OLD.ID != NEW.ID) THEN
		INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
			VALUES('U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'servicio',
				   'Id',OLD.ID,NEW.ID);    
	END IF;
 
 	IF (OLD.nombre != NEW.nombre) THEN
		INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
			VALUES('U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'servicio',
				   'nombre',OLD.nombre,NEW.nombre);    
	END IF;
    
    IF (OLD.duracion <> NEW.duracion) THEN
        INSERT INTO auditoria VALUES (NULL,'U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'servicio','duracion',OLD.duracion,NEW.duracion);
    END IF;

    IF (OLD.precio <> NEW.precio) THEN
        INSERT INTO auditoria VALUES (NULL,'U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'servicio','precio',OLD.precio,NEW.precio);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `servicio_AFTER_DELETE` AFTER DELETE ON `servicio` FOR EACH ROW BEGIN
	INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
		VALUES('D',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'servicio',
			   'Id',OLD.id,NULL);
	
    INSERT INTO auditoria VALUES (NULL,'D',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),
		'servicio','nombre',OLD.nombre,NULL);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `id` varchar(10) NOT NULL,
  `primer_nombre` varchar(15) NOT NULL,
  `segundo_nombre` varchar(15) DEFAULT NULL,
  `primer_apellido` varchar(15) NOT NULL,
  `segundo_apellido` varchar(15) DEFAULT NULL,
  `correo_electronico` varchar(200) NOT NULL,
  `direccion` varchar(200) NOT NULL,
  `telefono` varchar(10) NOT NULL,
  `n_de_mascotas` varchar(3) NOT NULL,
  `contrasena` varchar(15) NOT NULL,
  `id_veterinario_o_zootecnista` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `correo_electronico` (`correo_electronico`),
  KEY `fk_veterinario` (`id_veterinario_o_zootecnista`),
  CONSTRAINT `fk_veterinario` FOREIGN KEY (`id_veterinario_o_zootecnista`) REFERENCES `veterinario_o_zootecnista` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` (`id`, `primer_nombre`, `segundo_nombre`, `primer_apellido`, `segundo_apellido`, `correo_electronico`, `direccion`, `telefono`, `n_de_mascotas`, `contrasena`, `id_veterinario_o_zootecnista`) VALUES ('1050797430','Carolina',NULL,'Molina','Moreno','carolina.07molina@gmail.com','Calle 53 #25A-35 Pereira','3014656474','1','Moreno1998','1004634002');
INSERT INTO `usuario` (`id`, `primer_nombre`, `segundo_nombre`, `primer_apellido`, `segundo_apellido`, `correo_electronico`, `direccion`, `telefono`, `n_de_mascotas`, `contrasena`, `id_veterinario_o_zootecnista`) VALUES ('1051801555','Yesid','Esteban','Romero','Osorio','yesid.romero2004@gmail.com','Calle 10 #5-51 Pereira','3182466130','2','Romero2014','1002234684');
INSERT INTO `usuario` (`id`, `primer_nombre`, `segundo_nombre`, `primer_apellido`, `segundo_apellido`, `correo_electronico`, `direccion`, `telefono`, `n_de_mascotas`, `contrasena`, `id_veterinario_o_zootecnista`) VALUES ('1052795396','Cristina',NULL,'Hurtado','Mendez','cristina.hurtado05@gmail.com','Calle 9 #9-62 Pereira','3003158068','1','GatoLuna78','1102632848');
INSERT INTO `usuario` (`id`, `primer_nombre`, `segundo_nombre`, `primer_apellido`, `segundo_apellido`, `correo_electronico`, `direccion`, `telefono`, `n_de_mascotas`, `contrasena`, `id_veterinario_o_zootecnista`) VALUES ('1053796646','Leidy','Teresa','Rivera','Pinzón','rivera.teresa2006@gmail.com','Carrera 21 #17-63 Pereira','3168288235','1','EaUoIa456','1004633134');
INSERT INTO `usuario` (`id`, `primer_nombre`, `segundo_nombre`, `primer_apellido`, `segundo_apellido`, `correo_electronico`, `direccion`, `telefono`, `n_de_mascotas`, `contrasena`, `id_veterinario_o_zootecnista`) VALUES ('43589632','Sam','Luna','Orozco','Osorio','lunita21@gmail.com','Calle 12 #7-10, Pereira','3188885214','1','SamLun21',NULL);
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `verificar_usuario_antes_insert` BEFORE INSERT ON `usuario` FOR EACH ROW BEGIN
    DECLARE existe INT;
    
    -- Verifica si ya existe un usuario con el mismo ID
    IF EXISTS (SELECT 1 FROM usuario WHERE id = NEW.id) THEN
    
        -- Si el ID ya existe, genera un error
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El ID del usuario ya existe.';
    END IF;
    
    -- Validar que ID no esté vacío
    IF NEW.id IS NULL OR NEW.id = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El ID del usuario no puede estar vacío';
    END IF;

    -- Validar que número de mascotas no sea negativo
    IF NEW.n_de_mascotas < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El número de mascotas no puede ser negativo';
    END IF;

	-- Verifica si ya existe un usuario con el mismo correo
    SELECT COUNT(*) INTO existe
    FROM usuario
    WHERE correo_electronico = NEW.correo_electronico;

    IF existe > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Ya existe un usuario con este correo electrónico';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `usuario_AFTER_INSERT` AFTER INSERT ON `usuario` FOR EACH ROW BEGIN
		INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
		VALUES('I',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'usuario',
			   'Id',NULL,NEW.id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `usuario_BEFORE_UPDATE` BEFORE UPDATE ON `usuario` FOR EACH ROW BEGIN
	DECLARE existe INT;
    
    -- Verifica si ya existe un usuario con el mismo ID
    IF EXISTS (SELECT 1 FROM usuario WHERE id = NEW.id) THEN
    
        -- Si el ID ya existe, genera un error
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El ID del usuario ya existe.';
    END IF;
    
    -- Validar que ID no esté vacío
    IF NEW.id IS NULL OR NEW.id = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El ID del usuario no puede estar vacío';
    END IF;

    -- Validar que número de mascotas no sea negativo
    IF NEW.n_de_mascotas < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El número de mascotas no puede ser negativo';
    END IF;

	-- Verifica si ya existe un usuario con el mismo correo
    SELECT COUNT(*) INTO existe
    FROM usuario
    WHERE correo_electronico = NEW.correo_electronico;

    IF existe > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Ya existe un usuario con este correo electrónico';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `usuario_AFTER_UPDATE` AFTER UPDATE ON `usuario` FOR EACH ROW BEGIN
	IF (OLD.ID != NEW.ID) THEN
		INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
			VALUES('U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'usuario',
				   'Id',OLD.ID,NEW.ID);    
	END IF;
 
 	IF (OLD.primer_nombre != NEW.primer_nombre) THEN
		INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
			VALUES('U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'usuario',
				   'primer_nombre',OLD.primer_nombre,NEW.primer_nombre);    
	END IF;
 
 	IF (OLD.segundo_nombre != NEW.segundo_nombre) THEN
		INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
			VALUES('U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'usuario',
				   'segundo_nombre',OLD.segundo_nombre,NEW.segundo_nombre);    
	END IF;
 
 	IF (OLD.primer_apellido != NEW.primer_apellido) THEN
		INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
			VALUES('U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'usuario',
				   'primer_apellido',OLD.primer_apellido,NEW.primer_apellido);    
	END IF;    
 
 	IF (OLD.segundo_apellido != NEW.segundo_apellido) THEN
		INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
			VALUES('U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'usuario',
				   'segundo_apellido',OLD.segundo_apellido,NEW.segundo_apellido);    
	END IF; 
 
 	IF (OLD.correo_electronico != NEW.correo_electronico) THEN
		INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
			VALUES('U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'usuario',
				   'correo_electronico',OLD.correo_electronico,NEW.correo_electronico);    
	END IF;
    
 	IF (OLD.direccion != NEW.direccion) THEN
		INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
			VALUES('U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'usuario',
				   'direccion',OLD.direccion,NEW.direccion);    
	END IF;
 
 	IF (OLD.telefono != NEW.telefono) THEN
		INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
			VALUES('U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'usuario',
				   'telefono',OLD.telefono,NEW.telefono); 
	END IF;
    
    IF (OLD.n_de_mascotas != NEW.n_de_mascotas) THEN
		INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
			VALUES('U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'usuario',
				   'n_de_mascotas',OLD.n_de_mascotas,NEW.n_de_mascotas);    
	END IF;
 
 	IF (OLD.id_veterinario_o_zootecnista != NEW.id_veterinario_o_zootecnista) THEN
		INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
			VALUES('U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'usuario',
				   'id_veterinario_o_zootecnista',OLD.id_veterinario_o_zootecnista,NEW.id_veterinario_o_zootecnista);    
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `usuario_AFTER_DELETE` AFTER DELETE ON `usuario` FOR EACH ROW BEGIN
	INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
		VALUES('D',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'usuario',
			   'Id',OLD.id,NULL);
               
	INSERT INTO auditoria VALUES (NULL,'D',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),
		'usuario','correo_electronico',OLD.correo_electronico,NULL);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `veterinario_o_zootecnista`
--

DROP TABLE IF EXISTS `veterinario_o_zootecnista`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `veterinario_o_zootecnista` (
  `id` varchar(10) NOT NULL,
  `primer_nombre` varchar(15) NOT NULL,
  `segundo_nombre` varchar(15) DEFAULT NULL,
  `primer_apellido` varchar(15) NOT NULL,
  `segundo_apellido` varchar(15) DEFAULT NULL,
  `correo_electronico` varchar(200) NOT NULL,
  `telefono` varchar(10) NOT NULL,
  `direccion_clinica` varchar(200) NOT NULL,
  `contrasena` varchar(15) NOT NULL,
  `descripcion_de_perfil` varchar(2000) DEFAULT NULL,
  `promedio_calificaciones` float NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `correo_electronico` (`correo_electronico`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `veterinario_o_zootecnista`
--

LOCK TABLES `veterinario_o_zootecnista` WRITE;
/*!40000 ALTER TABLE `veterinario_o_zootecnista` DISABLE KEYS */;
INSERT INTO `veterinario_o_zootecnista` (`id`, `primer_nombre`, `segundo_nombre`, `primer_apellido`, `segundo_apellido`, `correo_electronico`, `telefono`, `direccion_clinica`, `contrasena`, `descripcion_de_perfil`, `promedio_calificaciones`) VALUES ('1002234684','Gloria','Alejandra','Gonzalez','Herrera','gonzalezaleja@gmail.com','3005419535','Calle 23 #15–47 Pereira','perro3412','Especialista en medicina veterinaria con énfasis en nutrición y comportamiento animal. Con una visión holística del cuidado de las mascotas, trabaja por mejorar su calidad de vida a través de un trato responsable, empático y personalizado en cada consulta.',4.6);
INSERT INTO `veterinario_o_zootecnista` (`id`, `primer_nombre`, `segundo_nombre`, `primer_apellido`, `segundo_apellido`, `correo_electronico`, `telefono`, `direccion_clinica`, `contrasena`, `descripcion_de_perfil`, `promedio_calificaciones`) VALUES ('1004633134','Nohemi',NULL,'Jaramillo','Moncada','nohemi@gmail.com','3187274669','El Progreso, Av. del Río #29a-13, Pereira','AeIoUy123','Médica veterinaria con sólida experiencia en diagnóstico clínico y manejo preventivo de enfermedades en pequeñas especies. Destaca por su sensibilidad y dedicación al bienestar animal, brindando una atención cercana y confiable tanto al paciente como a sus familias humanas.',4.5);
INSERT INTO `veterinario_o_zootecnista` (`id`, `primer_nombre`, `segundo_nombre`, `primer_apellido`, `segundo_apellido`, `correo_electronico`, `telefono`, `direccion_clinica`, `contrasena`, `descripcion_de_perfil`, `promedio_calificaciones`) VALUES ('1004634002','Maria','Esmeralda','Sierra','Perez','maressierra@gmail.com','3188653147','Corales Manzana 26, Casa 9, Pereira','FloresHer123','Veterinaria apasionada por la medicina general y la promoción de la salud animal. Con enfoque preventivo y una atención centrada en el paciente, se destaca por su trato humano, vocación de servicio y compromiso con el cuidado integral de perros y gatos.',3.3);
INSERT INTO `veterinario_o_zootecnista` (`id`, `primer_nombre`, `segundo_nombre`, `primer_apellido`, `segundo_apellido`, `correo_electronico`, `telefono`, `direccion_clinica`, `contrasena`, `descripcion_de_perfil`, `promedio_calificaciones`) VALUES ('1102632848','Karen','Marcela','Munera','Lopez','karen9912@gmail.com','3112812609','Av. Circunvalar 3-27, Circunvalar, Pereira','Fluffy123','Médica veterinaria con formación en medicina interna y cuidados intensivos, dedicada a ofrecer atención integral a animales de compañía. Su enfoque se basa en el respeto y empatía hacia cada paciente, brindando tratamientos personalizados con alto compromiso ético y profesionalismo.',2.9);
/*!40000 ALTER TABLE `veterinario_o_zootecnista` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `verificar_vetzoo_antes_insert` BEFORE INSERT ON `veterinario_o_zootecnista` FOR EACH ROW BEGIN
    DECLARE existe INT;
    
    -- Verifica si ya existe un veterinario o zootecnista con el mismo ID
    IF EXISTS (SELECT 1 FROM veterinario_o_zootecnista WHERE id = NEW.id) THEN
        -- Si el ID ya existe, genera un error
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El ID del veterinario o zootecnista ya existe.';
    END IF;
    
    -- Validar que ID no esté vacío
    IF NEW.id IS NULL OR NEW.id = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El ID del usuario no puede estar vacío';
    END IF;

	-- Verifica si ya existe un veterinario con el mismo correo
    SELECT COUNT(*) INTO existe
    FROM usuario
    WHERE correo_electronico = NEW.correo_electronico;

    IF existe > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Ya existe un veterinario o zootecnista con este correo electrónico';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `veterinario_o_zootecnista_AFTER_INSERT` AFTER INSERT ON `veterinario_o_zootecnista` FOR EACH ROW BEGIN
	INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
		VALUES('I',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'veterinario_o_zootecnista',
			   'Id',NULL,NEW.id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `veterinario_o_zootecnista_BEFORE_UPDATE` BEFORE UPDATE ON `veterinario_o_zootecnista` FOR EACH ROW BEGIN
DECLARE existe INT;
    
    -- Verifica si ya existe un veterinario o zootecnista con el mismo ID
    IF EXISTS (SELECT 1 FROM veterinario_o_zootecnista WHERE id = NEW.id) THEN
        -- Si el ID ya existe, genera un error
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El ID del veterinario o zootecnista ya existe.';
    END IF;
    
    -- Validar que ID no esté vacío
    IF NEW.id IS NULL OR NEW.id = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El ID del usuario no puede estar vacío';
    END IF;

	-- Verifica si ya existe un veterinario con el mismo correo
    SELECT COUNT(*) INTO existe
    FROM usuario
    WHERE correo_electronico = NEW.correo_electronico;

    IF existe > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Ya existe un veterinario o zootecnista con este correo electrónico';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `veterinario_o_zootecnista_AFTER_UPDATE` AFTER UPDATE ON `veterinario_o_zootecnista` FOR EACH ROW BEGIN
	IF (OLD.primer_nombre <> NEW.primer_nombre) THEN
        INSERT INTO auditoria VALUES (NULL,'U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'veterinario_o_zootecnista','primer_nombre',OLD.primer_nombre,NEW.primer_nombre);
    END IF;
    
    IF (OLD.segundo_nombre <> NEW.segundo_nombre) THEN
        INSERT INTO auditoria VALUES (NULL,'U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'veterinario_o_zootecnista','segundo_nombre',OLD.segundo_nombre,NEW.segundo_nombre);
    END IF;
    
    IF (OLD.primer_apellido <> NEW.primer_apellido) THEN
        INSERT INTO auditoria VALUES (NULL,'U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'veterinario_o_zootecnista','primer_apellido',OLD.primer_apellido,NEW.primer_apellido);
    END IF;
    
    IF (OLD.segundo_apellido <> NEW.segundo_apellido) THEN
        INSERT INTO auditoria VALUES (NULL,'U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'veterinario_o_zootecnista','segundo_apellido',OLD.segundo_apellido,NEW.segundo_apellido);
    END IF;
    
    IF (OLD.correo_electronico <> NEW.correo_electronico) THEN
        INSERT INTO auditoria VALUES (NULL,'U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'veterinario_o_zootecnista','correo_electronico',OLD.correo_electronico,NEW.correo_electronico);
    END IF;
    
    IF (OLD.telefono <> NEW.telefono) THEN
        INSERT INTO auditoria VALUES (NULL,'U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'veterinario_o_zootecnista','telefono',OLD.telefono,NEW.telefono);
    END IF;
    
    IF (OLD.direccion_clinica <> NEW.direccion_clinica) THEN
        INSERT INTO auditoria VALUES (NULL,'U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'veterinario_o_zootecnista','direccion_clinica',OLD.direccion_clinica,NEW.direccion_clinica);
    END IF;

    IF (OLD.descripcion_de_perfil <> NEW.descripcion_de_perfil) THEN
        INSERT INTO auditoria VALUES (NULL,'U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'veterinario_o_zootecnista','descripcion_de_perfil',OLD.descripcion_de_perfil,NEW.descripcion_de_perfil);
    END IF;
    
    IF (OLD.promedio_calificaciones <> NEW.promedio_calificaciones) THEN
        INSERT INTO auditoria VALUES (NULL,'U',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'veterinario_o_zootecnista','promedio_calificaciones',OLD.promedio_calificaciones,NEW.promedio_calificaciones);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`practica`@`%`*/ /*!50003 TRIGGER `veterinario_o_zootecnista_AFTER_DELETE` AFTER DELETE ON `veterinario_o_zootecnista` FOR EACH ROW BEGIN
	INSERT INTO auditoria (transaccion,fechahora,usuario,tabla,campo,valor_anterior,valor_nuevo)
		VALUES('D',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),'veterinario_o_zootecnista',
			   'Id',OLD.id,NULL);
               
	INSERT INTO auditoria VALUES (NULL,'D',NOW(),SUBSTRING_INDEX(CURRENT_USER(),'@',1),
		'veterinario_o_zootecnista','correo_electronico',OLD.correo_electronico,NULL);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'patassinbarreras'
--

--
-- Dumping routines for database 'patassinbarreras'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-23 18:04:17
