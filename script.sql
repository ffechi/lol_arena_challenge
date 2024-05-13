--Script realizado por ff3chi
--Libre uso, modificacion y distribucion
--Cualquier error o pregunta contactar por @ff3chi via Twitter

DROP DATABASE IF EXISTS lol_arena_challenge;
CREATE DATABASE lol_arena_challenge;
USE lol_arena_challenge;

CREATE TABLE campeones(
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(100)
);

CREATE TABLE primeros_puestos(
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	id_campeon INT UNSIGNED,
	nombre_campeon VARCHAR(100),
	fecha_logro DATE,
	numero_intentos INT,
	nota_proceso_obtencion INT,
	descripcion VARCHAR(1000),
	FOREIGN KEY (id_campeon) REFERENCES campeones(id)
);

INSERT INTO campeones(nombre) VALUES 
('Aatrox'), ('Ahri'), ('Akali'), ('Akshan'), ('Alistar'),
('Amumu'), ('Anivia'), ('Annie'), ('Aphelios'), ('Ashe'),
('Aurelion Sol'), ('Azir'), ('Bardo'), ('Bel veth'), ('Blitzcrank'),
('Brand'), ('Braum'), ('Briar'), ('Caitlyn'), ('Camille'),
('Cassiopeia'), ('Cho gat'), ('Corki'), ('Darius'), ('Diana'),
('Dr Mundo'), ('Draven'), ('Ekko'), ('Elise'), ('Evelynn'),
('Ezreal'), ('Fiddlesticks'), ('Fiora'), ('Fizz'), ('Galio'),
('Gangplank'), ('Garen'), ('Gnar'), ('Gragas'), ('Graves'),
('Gwen'), ('Hecarim'), ('Heimerdinger'), ('Hwei'), ('Illaoi'),
('Irelia'), ('Ivern'), ('Janna'), ('Jarvan IV'), ('Jax'),
('Jayce'), ('Jhin'), ('Jinx'), ('K sante'), ('Kai sa'),
('Kalista'), ('Karma'), ('Karthus'), ('Kassadin'), ('Katarina'),
('Kayle'), ('Kayn'), ('Kennen'), ('Kha zix'), ('Kindred'),
('Kled'), ('Kog Maw'), ('LeBlanc'), ('Lee Sin'), ('Leona'),
('Lillia'), ('Lissandra'), ('Lucian'), ('Lulu'), ('Lux'),
('Maestro Yi'), ('Malphite'), ('Malzahar'), ('Maokai'), ('Milio'),
('Miss Fortune'), ('Mordekaiser'), ('Morgana'), ('Naafiri'), ('Nami'),
('Nasus'), ('Nautilus'), ('Neeko'), ('Nidalee'), ('Nilah'),
('Nocturne'), ('Nunu y Willump'), ('Olaf'), ('Orianna'), ('Ornn'),
('Pantheon'), ('Poppy'), ('Pyke'), ('Qiyana'), ('Quinn'), 
('Rakan'), ('Rammus'), ('Rek sai'), ('Rell'), ('Renata Glasc'),
('Renekton'), ('Rengar'), ('Riven'), ('Rumble'), ('Ryze'),
('Samira'), ('Sejuani'), ('Senna'), ('Seraphine'), ('Sett'),
('Shaco'), ('Shen'), ('Shyvana'), ('Singed'), ('Sion'),
('Sivir'), ('Skarner'), ('Smolder'), ('Sona'), ('Soraka'),
('Swain'), ('Sylas'), ('Syndra'), ('Tahm Kench'), ('Taliyah'),
('Talon'), ('Taric'), ('Teemo'), ('Thresh'), ('Tristana'),
('Trundle'), ('Tryndamere'), ('Twisted Fate'), ('Twitch'), ('Udyr'),
('Urgot'), ('Varus'), ('Vayne'), ('Veigar'), ('Vel Koz'),
('Vex'), ('Vi'), ('Viego'), ('Viktor'), ('Vladimir'),
('Volibear'), ('Warwick'), ('Wukong'), ('Xayah'), ('Xerath'),
('Xin Zhao'), ('Yasuo'), ('Yone'), ('Yorick'), ('Yuumi'),
('Zac'), ('Zed'), ('Zeri'), ('Ziggs'), ('Zilean'),
('Zoe'), ('Zyra')
;

DELIMITER $$
CREATE TRIGGER actualizar_fecha_logro 
BEFORE INSERT ON primeros_puestos
FOR EACH ROW
BEGIN
    SET NEW.fecha_logro = CURDATE();
END$$
DELIMITER ;


DELIMITER $$
DROP PROCEDURE IF EXISTS he_ganado$$
CREATE PROCEDURE he_ganado(nombre_campeon_i VARCHAR(100), numero_intentos_i INT, nota_proceso_obtencion_i INT, descripcion_i VARCHAR(1000))
BEGIN
	DECLARE id_campeon_i INT UNSIGNED;
	SET id_campeon_i = (
		SELECT id
		FROM campeones
		WHERE nombre = nombre_campeon_i
	);
	INSERT INTO primeros_puestos (id_campeon, nombre_campeon, numero_intentos, nota_proceso_obtencion, descripcion)
	VALUES (id_campeon_i, nombre_campeon_i, numero_intentos_i, nota_proceso_obtencion_i, descripcion_i);
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS cuantos_faltan$$
CREATE PROCEDURE cuantos_faltan()
BEGIN   
	SELECT nombre as Nombre_Campeon
	FROM campeones c LEFT JOIN primeros_puestos pp ON c.id = pp.id_campeon
	WHERE c.id NOT IN (SELECT id_campeon
					   FROM primeros_puestos);
					   
	SELECT COUNT(*) AS Numero_De_Personajes_Restantes
	FROM campeones c LEFT JOIN primeros_puestos pp ON c.id = pp.id_campeon
	WHERE c.id NOT IN (SELECT id_campeon
					   FROM primeros_puestos);
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS cuantos_tengo$$
CREATE PROCEDURE cuantos_tengo()
BEGIN   
	SELECT nombre as Nombre_Campeon
	FROM campeones c LEFT JOIN primeros_puestos pp ON c.id = pp.id_campeon
	WHERE c.id IN (SELECT id_campeon
					   FROM primeros_puestos);
					   
	SELECT COUNT(*) AS Numero_De_Personajes_Conseguidos
	FROM campeones c LEFT JOIN primeros_puestos pp ON c.id = pp.id_campeon
	WHERE c.id IN (SELECT id_campeon
					   FROM primeros_puestos);
END$$
DELIMITER ;

DELIMITER $$
DROP FUNCTION IF EXISTS comprobar_personaje$$
CREATE FUNCTION comprobar_personaje(nombre_i VARCHAR(100)) RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
	DECLARE resultado VARCHAR(100);
	
	DECLARE resultado_busqueda VARCHAR(100);
	SET resultado_busqueda = (
		SELECT id
		FROM primeros_puestos
		WHERE nombre_campeon = nombre_i
	);
	
	IF resultado_busqueda IS NULL THEN
		SET resultado = CONCAT('No has quedado en primera posicion con', ' ', nombre_i);
	ELSE
		SET resultado = CONCAT('Has quedado en primera posicion con', ' ', nombre_i);
	END IF;
	RETURN resultado;
END$$
DELIMITER ;