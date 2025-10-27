BEGIN TRANSACTION;
INSERT INTO "doctrine_migration_versions" VALUES ('DoctrineMigrations\Version20251027140607','2025-10-27 08:06:09',2);
INSERT INTO "user" VALUES (1,'iner','["ROLE_USER","ROLE_SUPER_ADMIN","ROLE_ADMIN"]','$2y$13$QC8jjTPtDTApjMAKgpsWcejNXdsGYvFL.iadTBEO9PiIM.i1eol86','Coordinación de sistemas');
COMMIT;
