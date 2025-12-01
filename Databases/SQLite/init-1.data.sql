BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS user (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, username VARCHAR(180) NOT NULL, roles CLOB NOT NULL --(DC2Type:json)
        , password VARCHAR(255) NOT NULL, name VARCHAR(255) NOT NULL);
INSERT INTO "user" ("id","username","roles","password","name") VALUES (1,'iner','["ROLE_USER","ROLE_SUPER_ADMIN","ROLE_ADMIN"]','$2y$13$QC8jjTPtDTApjMAKgpsWcejNXdsGYvFL.iadTBEO9PiIM.i1eol86','Coordinación de sistemas');
INSERT INTO "user" ("id","username","roles","password","name") VALUES (2,'oficial1','["ROLE_USER","ROLE_ADMIN"]','$2y$13$ep4BPw3MK.FJi80wpJw.t.a63shVDIP6y/kdRXvdSx5Q1gJChknU.','Administrador de Vigilancia');
INSERT INTO "user" ("id","username","roles","password","name") VALUES (3,'oficial2','["ROLE_USER"]','$2y$13$K3VPFqYE48tr.h1PLDoroeLPGducwih9jTAcJpSrRKoZnTkJ37O/i','Oficial de Vigilancia');
CREATE UNIQUE INDEX UNIQ_IDENTIFIER_USERNAME ON user (username);
COMMIT;
