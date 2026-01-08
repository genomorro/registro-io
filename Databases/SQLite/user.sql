PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS user (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, username VARCHAR(180) NOT NULL, roles CLOB NOT NULL --(DC2Type:json)
        , password VARCHAR(255) NOT NULL, name VARCHAR(255) NOT NULL);
INSERT INTO "user" ("id","username","roles","password","name") VALUES (1,'iner','["ROLE_USER","ROLE_ADMIN","ROLE_SUPER_ADMIN"]','$2y$13$qB6pSIFpMa7MDo63bBVv4umNDPpbzWd/S6khhc/V1DS/Z0qlK.i8O','Coordinación de sistemas');
INSERT INTO "user" ("id","username","roles","password","name") VALUES (2,'coordinacion','["ROLE_USER","ROLE_ADMIN"]','$2y$13$lSe2XY2fgmoqdcknFIJNr.ZmzKr0P4m20Pq6Klftp4yKpk3CPgyBC','Yazmín Santiago Espinosa');
INSERT INTO "user" ("id","username","roles","password","name") VALUES (3,'oficial','["ROLE_USER"]','$2y$13$LmrxC1kW003N.b.Bq5P.H.l/QabK0NPoa7FWZ5.08PPNAvN8qp9FW','Oficial de Vigilancia');
INSERT INTO "user" ("id","username","roles","password","name") VALUES (4,'Jefe_Servicio','["ROLE_USER"]','$2y$13$ayzvOKNVDswnT8QTjnLJR.f1AGbjRe2.KbMs2iI8pPuqNyToihY56','Juan Jose Mejia Lozada');
INSERT INTO "user" ("id","username","roles","password","name") VALUES (5,'Jefa_Turno_A','["ROLE_USER"]','$2y$13$UergpkKH6zYUjXu.Wc1Tkek8R/ueXv.Qe.BBsad6pfvU1jI.IIUQW','Laura Berenice Romero Tejada');
INSERT INTO "user" ("id","username","roles","password","name") VALUES (6,'Jefa_Turno_B','["ROLE_USER"]','$2y$13$qwVlHfw8Vli.Bm6DzMkvZuBFn.bmFXmfJnVQEMS1DHoAats1is3sG','Maria Cruz Hernandez Galicia');
CREATE UNIQUE INDEX UNIQ_IDENTIFIER_USERNAME ON user (username);
COMMIT;
