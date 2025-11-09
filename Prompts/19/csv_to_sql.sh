#!/bin/bash

# MySQL/MariaDB
echo "-- patient" > patient-mysql.sql
awk -F, 'NR > 1 {
    id = $1
    file = $2
    name = $3
    disability = $4
    gsub(/\r$/, "", disability) 
    printf "INSERT INTO patient (id, file, name, disability) VALUES (%s, \x27%s\x27, \x27%s\x27, %s) ON DUPLICATE KEY UPDATE file = \x27%s\x27, name = \x27%s\x27, disability = %s;\n", id, file, name, disability, file, name, disability
}' patient.csv >> patient-mysql.sql

echo "" >> patient-mysql.sql
echo "-- appointment" >> appointment-mysql.sql
awk -F, 'NR > 1 {
    id = $1
    patient_id = $2
    place = $3
    date_at = $4
    type = $5
    gsub(/\r$/, "", type)
    printf "INSERT INTO appointment (id, patient_id, place, date_at, type) VALUES (%s, %s, \x27%s\x27, \x27%s\x27, \x27%s\x27) ON DUPLICATE KEY UPDATE patient_id = %s, place = \x27%s\x27, date_at = \x27%s\x27, type = \x27%s\x27;\n", id, patient_id, place, date_at, type, patient_id, place, date_at, type
}' appointment.csv >> appointment-mysql.sql

# SQLite3
echo "-- patient" > patient-sqlite.sql
awk -F, 'NR > 1 {
    id = $1
    file = $2
    name = $3
    disability = $4
    gsub(/\r$/, "", disability)
    printf "INSERT INTO patient (id, file, name, disability) VALUES (%s, \x27%s\x27, \x27%s\x27, %s) ON CONFLICT(id) DO UPDATE SET file = excluded.file, name = excluded.name, disability = excluded.disability;\n", id, file, name, disability
}' patient.csv >> patient-sqlite.sql

echo "" >> patient-sqlite.sql
echo "-- appointment" >> appointment-sqlite.sql
awk -F, 'NR > 1 {
    id = $1
    patient_id = $2
    place = $3
    date_at = $4
    type = $5
    gsub(/\r$/, "", type)
    printf "INSERT INTO appointment (id, patient_id, place, date_at, type) VALUES (%s, %s, \x27%s\x27, \x27%s\x27, \x27%s\x27) ON CONFLICT(id) DO UPDATE SET patient_id = excluded.patient_id, place = excluded.place, date_at = excluded.date_at, type = excluded.type;\n", id, patient_id, place, date_at, type
}' appointment.csv >> appointment-sqlite.sql
