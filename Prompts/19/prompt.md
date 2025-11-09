CSV to SQL

Tengo dos archivos: `appointment.csv` y `patient.csv`.

`appointment.csv` tiene la siguiente estructura de columnas:

```
id,patient_id,place,date_at,type
```
`patient.csv tiene la siguiente estructura de columnas:

```
id,file,name,disability
```

Necesito transformar esos archivos CSV a scripts SQL que inserten una nueva fila o bien, actualicen los registros de una base de datos que puede estar en MySQL/MariaDB o en SQLite3

Si es SQLite3, las tablas correspondientes serían:

```SQLite3
CREATE TABLE IF NOT EXISTS "appointment" (
	"id"	INTEGER NOT NULL,
	"patient_id"	INTEGER NOT NULL,
	"place"	VARCHAR(255) NOT NULL,
	"date_at"	DATETIME NOT NULL,
	"type"	VARCHAR(255) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	CONSTRAINT "FK_FE38F8446B899279" FOREIGN KEY("patient_id") REFERENCES "patient"("id") NOT DEFERRABLE INITIALLY IMMEDIATE
);
CREATE TABLE IF NOT EXISTS "patient" (
	"id"	INTEGER NOT NULL,
	"file"	VARCHAR(12) NOT NULL,
	"name"	VARCHAR(255) NOT NULL,
	"disability"	BOOLEAN NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
```
Para MariaDB, las tablas correspondientes serían: 

```MySQL
CREATE TABLE `appointment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `patient_id` int(11) NOT NULL,
  `place` varchar(255) NOT NULL,
  `date_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_FE38F8446B899279` (`patient_id`),
  CONSTRAINT `FK_FE38F8446B899279` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `patient` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file` varchar(12) NOT NULL,
  `name` varchar(255) NOT NULL,
  `disability` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```
Crea los dos scripts correspondientes.

Como sugerencia, en el caso de MariaDB, puedes usar una sentencia similar a esta:

```MySQL
INSERT INTO tabla (campo1,campo2)
VALUES (valor1, valor2)
ON DUPLICATE KEY UPDATE
   campo1 = valor1, 
   campo2 = valor2,
   ...;
```
Por ejemplo:
```MySQL
INSERT INTO patient (id, file, name, disability)
VALUES (1,'000028567','BLANDINA HERNANDEZ PAREDES',0)
ON DUPLICATE KEY UPDATE
   id = 1, 
   file = '000028567',
   ...;
```
Puedes ver mejor documentación en https://www.mysqltutorial.org/mysql-basics/mysql-insert-or-update-on-duplicate-key-update/

Y en el script de SQLite3 puedes usar la clausula UPSERT, documentada con ejemplos en el siguiente enlace https://sqlite.org/lang_upsert.html

***
Así es el contenido de los archivos CSV. 

patient.csv:

```
id,file,name,disability
1,000028567,BLANDINA HERNANDEZ PAREDES,0
2,000028878,FRANCISCO ARIZA BRAVO,0
3,000028915,JUAN SANTIN ROSEL,0
4,000028974,CARMELO REYES PACHECO,0
5,000029064,ANTONIA LARA HERRERA,0
6,000029083,TELESFORO HERNANDEZ GONZALEZ,0
7,000029181,SILVIA TERESITA FUENTES RIVERA,0
8,000029212,DULCE MARIA BERENICE REZA VERGARA,0
9,000029630,FRANCISCO JAVIER BAEZ ALDAMA,0
10,000029897,ARNULFO DIAZ BARRAGAN,0
```

appointment.csv:

```
id,patient_id,place,date_at,type
1068560,117096,ALERGOLOGIA C1 - DR. GANDHI,2032-01-05 10:00:00,Cita
1069399,150583,GERIATRÍA SEGUIMIENTO SARS-COV-2,2033-01-13 09:00:00,Cita
1071766,130297,ALERGOLOGIA C1 - DR. GANDHI,2032-01-12 10:00:00,Cita
1071865,117973,ALERGOLOGIA E INMUNOLOGIA C1,2032-01-28 10:00:00,Cita
1213097,518444,DR. GUSTAVO IVAN CENTENO SAENZ,2034-01-26 10:30:00,Cita
1320803,124439,TB - DRA. NORMA ANGÉLICA TÉLLEZ NAVARRETE,2028-06-07 10:00:00,Cita
1329585,122214,AUDIOLOGIA 3 DR. LARA,2026-01-05 11:00:00,Cita
1335178,114581,CONSULTORIO DEL SUEÑO,2025-11-28 09:40:00,Cita
1335190,637821,CONSULTORIO DEL SUEÑO,2025-11-28 09:40:00,Cita
1336738,666081,TELECONSULTA - CONSULTORIO DEL SUEÑO,2025-11-14 12:00:00,Cita
```

***
Esta tarea la repetiré constantemente, así que de ser posible, elabora también un script que automatice esta tarea. Puedes usar Bash para este último script, así no requerirá dependencias complejas al ejecutarlo en Linux.
