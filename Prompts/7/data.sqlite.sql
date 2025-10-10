-- Sample Data for 'registro-io' (1000 records for SQLite)

-- Disable foreign key checks to avoid order issues
PRAGMA foreign_keys=OFF;

-- Clear existing data
DELETE FROM visitor_patient;
DELETE FROM appointment;
DELETE FROM attendance;
DELETE FROM visitor;
DELETE FROM patient;

-- Reset autoincrement counters
DELETE FROM sqlite_sequence WHERE name IN ('patient', 'visitor', 'appointment', 'attendance');


-- Generate a sequence of 1000 numbers for seeding
CREATE TEMP TABLE N (i);
INSERT INTO N(i)
WITH RECURSIVE
  cnt(x) AS (
     SELECT 1
     UNION ALL
     SELECT x+1 FROM cnt
      LIMIT 1000
  )
SELECT x FROM cnt;


-- Patients (1000 records)
INSERT INTO patient (name, file, disability)
SELECT
    'Patient Name ' || i,
    printf('000%06d', abs(random()) % 1000000),
    abs(random()) % 2
FROM N;


-- Appointments (1000 records)
INSERT INTO appointment (patient_id, place, date_at, type)
SELECT
    (SELECT id FROM patient ORDER BY RANDOM() LIMIT 1),
    CASE abs(random()) % 30
        WHEN 0 THEN 'Consultorio 1'  WHEN 1 THEN 'Consultorio 2'  WHEN 2 THEN 'Consultorio 3'
        WHEN 3 THEN 'Consultorio 4'  WHEN 4 THEN 'Consultorio 5'  WHEN 5 THEN 'Consultorio 6'
        WHEN 6 THEN 'Consultorio 7'  WHEN 7 THEN 'Consultorio 8'  WHEN 8 THEN 'Consultorio 9'
        WHEN 9 THEN 'Consultorio 10' WHEN 10 THEN 'Consultorio 11' WHEN 11 THEN 'Consultorio 12'
        WHEN 12 THEN 'Consultorio 13' WHEN 13 THEN 'Consultorio 14' WHEN 14 THEN 'Consultorio 15'
        WHEN 15 THEN 'Consultorio 16' WHEN 16 THEN 'Consultorio 17' WHEN 17 THEN 'Consultorio 18'
        WHEN 18 THEN 'Consultorio 19' WHEN 19 THEN 'Consultorio 20' WHEN 20 THEN 'Consultorio 21'
        WHEN 21 THEN 'Consultorio 22' WHEN 22 THEN 'Consultorio 23' WHEN 23 THEN 'Consultorio 24'
        WHEN 24 THEN 'Consultorio 25' WHEN 25 THEN 'Consultorio 26' WHEN 26 THEN 'Consultorio 27'
        WHEN 27 THEN 'Consultorio 28' WHEN 28 THEN 'Clínica de sueño' ELSE 'Hospital de día'
    END,
    datetime('now', '-' || (abs(random()) % 365) || ' days'),
    CASE abs(random()) % 3
        WHEN 0 THEN 'Estudio' WHEN 1 THEN 'Consulta' ELSE 'Procedimiento'
    END
FROM N;


-- Attendances (1000 records)
INSERT INTO attendance (patient_id, check_in_at, check_out_at, tag)
SELECT
    (SELECT id FROM patient ORDER BY RANDOM() LIMIT 1),
    datetime('now', '-' || (abs(random()) % 100) || ' hours'),
    CASE WHEN (abs(random()) % 10) > 1 THEN datetime('now', '-' || (abs(random()) % 24) || ' hours') ELSE NULL END,
    1000 + abs(random()) % 9000
FROM N;


-- Visitors (1000 records)
INSERT INTO visitor (name, phone, dni, tag, destination, check_in_at, check_out_at, relationship)
SELECT
    'Visitor Name ' || i,
    '555-01' || printf('%02d', i),
    CASE abs(random()) % 3
        WHEN 0 THEN 'INE' WHEN 1 THEN 'Cartilla militar' ELSE 'Licencia de conducir'
    END,
    1000 + abs(random()) % 9000,
    CASE abs(random()) % 4
        WHEN 0 THEN 'Radiología' WHEN 1 THEN 'Laboratorio' WHEN 2 THEN 'Consulta Externa' ELSE 'Urgencias'
    END,
    datetime('now', '-' || (abs(random()) % 100) || ' hours'),
    CASE WHEN (abs(random()) % 10) > 1 THEN datetime('now', '-' || (abs(random()) % 24) || ' hours') ELSE NULL END,
    CASE abs(random()) % 8
        WHEN 0 THEN 'Padre' WHEN 1 THEN 'Madre' WHEN 2 THEN 'Tío' WHEN 3 THEN 'Hermano'
        WHEN 4 THEN 'Sobrino' WHEN 5 THEN 'Abuelo' WHEN 6 THEN 'Nieto' ELSE 'Otro'
    END
FROM N;


-- Visitor-Patient Mappings (1000 records)
-- This approach ensures that each visitor is mapped to a single, unique, randomly selected patient, preventing duplicate pairs.
WITH
  visitors_with_rn AS (SELECT ROW_NUMBER() OVER() as rn, id FROM visitor),
  patients_with_rn AS (SELECT ROW_NUMBER() OVER() as rn, id FROM patient ORDER BY RANDOM())
INSERT INTO visitor_patient (visitor_id, patient_id)
SELECT
  v.id,
  p.id
FROM
  visitors_with_rn v
JOIN
  patients_with_rn p ON v.rn = p.rn;


-- Clean up temp table
DROP TABLE N;

-- Enable foreign key checks
PRAGMA foreign_keys=ON;