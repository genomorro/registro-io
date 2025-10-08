-- Sample Data for 'registro-io'

-- Disable foreign key checks to avoid order issues
SET FOREIGN_KEY_CHECKS=0;

-- Clear existing data
TRUNCATE TABLE visitor_patient;
TRUNCATE TABLE appointment;
TRUNCATE TABLE attendance;
TRUNCATE TABLE visitor;
TRUNCATE TABLE patient;


-- Patients (100 records)
INSERT INTO patient (id, file, name, disability)
SELECT
    i,
    LPAD(FLOOR(RAND() * 900000) + 100000, 9, '000'),
    CONCAT('Patient Name ', i),
    FLOOR(RAND() * 2)
FROM (
    SELECT @row := @row + 1 AS i FROM
    (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t1,
    (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t2,
    (SELECT @row := 0) r
) seq;

-- Appointments (100 records)
INSERT INTO appointment (patient_id, place, date_at, type)
SELECT
    FLOOR(1 + RAND() * 100),
    ELT(1 + FLOOR(RAND() * 30), 'Consultorio 1', 'Consultorio 2', 'Consultorio 3', 'Consultorio 4', 'Consultorio 5', 'Consultorio 6', 'Consultorio 7', 'Consultorio 8', 'Consultorio 9', 'Consultorio 10', 'Consultorio 11', 'Consultorio 12', 'Consultorio 13', 'Consultorio 14', 'Consultorio 15', 'Consultorio 16', 'Consultorio 17', 'Consultorio 18', 'Consultorio 19', 'Consultorio 20', 'Consultorio 21', 'Consultorio 22', 'Consultorio 23', 'Consultorio 24', 'Consultorio 25', 'Consultorio 26', 'Consultorio 27', 'Consultorio 28', 'Clínica de sueño', 'Hospital de día'),
    NOW() - INTERVAL FLOOR(RAND() * 365) DAY,
    ELT(1 + FLOOR(RAND() * 3), 'Estudio', 'Consulta', 'Procedimiento')
FROM patient;

-- Attendances (100 records)
INSERT INTO attendance (patient_id, check_in_at, check_out_at, tag)
SELECT
    FLOOR(1 + RAND() * 100),
    NOW() - INTERVAL FLOOR(RAND() * 100) HOUR,
    IF(RAND() > 0.2, NOW() - INTERVAL FLOOR(RAND() * 24) HOUR, NULL),
    FLOOR(1000 + RAND() * 9000)
FROM patient;

-- Visitors (100 records)
INSERT INTO visitor (id, name, phone, dni, tag, destination, check_in_at, check_out_at, relationship)
SELECT
    i,
    CONCAT('Visitor Name ', i),
    CONCAT('555-01', LPAD(i, 2, '0')),
    ELT(1 + FLOOR(RAND() * 3), 'INE', 'Cartilla militar', 'Licencia de conducir'),
    FLOOR(1000 + RAND() * 9000),
    ELT(1 + FLOOR(RAND() * 4), 'Radiología', 'Laboratorio', 'Consulta Externa', 'Urgencias'),
    NOW() - INTERVAL FLOOR(RAND() * 100) HOUR,
    IF(RAND() > 0.2, NOW() - INTERVAL FLOOR(RAND() * 24) HOUR, NULL),
    ELT(1 + FLOOR(RAND() * 8), 'Padre', 'Madre', 'Tío', 'Hermano', 'Sobrino', 'Abuelo', 'Nieto', 'Otro')
FROM (
    SELECT @visitor_id := @visitor_id + 1 AS i FROM
    (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t1,
    (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t2,
    (SELECT @visitor_id := 0) r
) seq;

-- Visitor-Patient Mappings (100 records)
INSERT INTO visitor_patient (visitor_id, patient_id)
SELECT
    FLOOR(1 + RAND() * 100),
    FLOOR(1 + RAND() * 100)
FROM patient;

-- Enable foreign key checks
SET FOREIGN_KEY_CHECKS=1;