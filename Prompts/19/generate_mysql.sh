#!/bin/bash

echo "-- patient" > output-mysql.sql
awk -F, 'NR > 1 {
    id = $1
    file = $2
    name = $3
    disability = $4
    gsub(/\r$/, "", disability) 
    printf "INSERT INTO patient (id, file, name, disability) VALUES (%s, \x27%s\x27, \x27%s\x27, %s) ON DUPLICATE KEY UPDATE file = \x27%s\x27, name = \x27%s\x27, disability = %s;\n", id, file, name, disability, file, name, disability
}' patient.csv >> output-mysql.sql

echo "" >> output-mysql.sql
echo "-- appointment" >> output-mysql.sql
awk -F, 'NR > 1 {
    id = $1
    patient_id = $2
    place = $3
    date_at = $4
    type = $5
    gsub(/\r$/, "", type)
    printf "INSERT INTO appointment (id, patient_id, place, date_at, type) VALUES (%s, %s, \x27%s\x27, \x27%s\x27, \x27%s\x27) ON DUPLICATE KEY UPDATE patient_id = %s, place = \x27%s\x27, date_at = \x27%s\x27, type = \x27%s\x27;\n", id, patient_id, place, date_at, type, patient_id, place, date_at, type
}' appointment.csv >> output-mysql.sql
