PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
INSERT INTO user VALUES(1,'iner','["ROLE_USER","ROLE_ADMIN","ROLE_SUPER_ADMIN"]','$2y$13$qB6pSIFpMa7MDo63bBVv4umNDPpbzWd/S6khhc/V1DS/Z0qlK.i8O','Coordinación de sistemas');
INSERT INTO user VALUES(2,'coordinacion','["ROLE_USER","ROLE_ADMIN"]','$2y$13$cUrZatF4.IEUAWU1jkl70O2RqwBGamPx.cSR6oxVnjGseX02IE0FW','Yazmín Santiago Espinosa');
INSERT INTO user VALUES(3,'oficial','["ROLE_USER"]','$2y$13$/utTzjwVsXfM7vrGrMo2g.rGpeQMwneM.Cf.LGLpAURK9BDoGzwv6','Oficial de Vigilancia');
COMMIT;
