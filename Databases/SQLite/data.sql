PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
INSERT INTO user VALUES(1,'iner','["ROLE_USER","ROLE_ADMIN","ROLE_SUPER_ADMIN"]','$2y$13$qB6pSIFpMa7MDo63bBVv4umNDPpbzWd/S6khhc/V1DS/Z0qlK.i8O','Coordinación de sistemas');
INSERT INTO user VALUES(2,'coordinacion','["ROLE_USER","ROLE_ADMIN"]','$2y$13$lSe2XY2fgmoqdcknFIJNr.ZmzKr0P4m20Pq6Klftp4yKpk3CPgyBC','Yazmín Santiago Espinosa');
INSERT INTO user VALUES(3,'oficial','["ROLE_USER"]','$2y$13$/utTzjwVsXfM7vrGrMo2g.rGpeQMwneM.Cf.LGLpAURK9BDoGzwv6','Oficial de Vigilancia');
INSERT INTO user VALUES(4,'Jefe_Servicio','["ROLE_USER"]','$2y$13$EeNIQ415CPYWR/B9eO1PFeCOio8rmeMXYmckPij1js8JuGzWSkeCm','Juan Jose Mejia Lozada');
INSERT INTO user VALUES(5,'Jefa_Turno_A','["ROLE_USER"]','$2y$13$UergpkKH6zYUjXu.Wc1Tkek8R/ueXv.Qe.BBsad6pfvU1jI.IIUQW','Laura Berenice Romero Tejada');
INSERT INTO user VALUES(6,'Jefa_Turno_B','["ROLE_USER"]','$2y$13$qwVlHfw8Vli.Bm6DzMkvZuBFn.bmFXmfJnVQEMS1DHoAats1is3sG','Maria Cruz Hernandez Galicia');
COMMIT;
