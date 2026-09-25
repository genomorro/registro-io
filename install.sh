#!/usr/bin/env bash

# ===========================================
# Script de despliegue para Symfony (prod)
# Fedora 41 + Apache
# ===========================================

GIT_ROOT=$(pwd)
APP_ROOT="$GIT_ROOT/public_html"
UPLOADS_DIR="$APP_ROOT/public/uploads"
VAR_DIR="$APP_ROOT/var"
HTTPD_USER="apache"

echo "Configurando Symfony en:"
echo "   GIT_ROOT: $GIT_ROOT"
echo "   APP_ROOT: $APP_ROOT"
echo "    VAR_DIR: $VAR_DIR"
echo "UPLOADS_DIR: $UPLOADS_DIR"
echo " HTTPD_USER: $HTTPD_USER"
echo

echo "Iniciando submódulos…"
cd "$GIT_ROOT" || exit 1
git submodule init
git submodule update

echo "Despliegue Symfony iniciado…"
cd "$APP_ROOT" || exit 1
# git config --system --add safe.directory "$APP_ROOT" 2>/dev/null || git config --global --add safe.directory "$APP_ROOT"
git checkout master

echo "Instalando dependencias Composer…"
composer install --no-dev --optimize-autoloader --no-interaction

echo "Instalando framework Gob.mx"
php bin/console app:gob-mx

echo "Ejecutando migraciones Doctrine…"
#php bin/console make:migration
php bin/console doctrine:migrations:migrate --no-interaction

echo "Habilitando entorno de producción…"
sqlite3 "$VAR_DIR/data_dev.db" ".read $GIT_ROOT/Databases/SQLite/user.sql"
cp "$VAR_DIR/data_dev.db" "$VAR_DIR/data_prod.db"
composer dump-env prod

echo "Limpiando y regenerando cache…"
php bin/console cache:clear --env=prod
php bin/console cache:warmup --env=prod

echo "Cargando assets…"
php bin/console importmap:install
php bin/console asset-map:compile
APP_ENV=prod php bin/console error:dump var/cache/prod/error_pages/ 403 404 500 502 503

echo
echo "CONFIGURACIÓN COMPLETA"
echo "Symfony se ha configurado correctamente."
echo
echo
echo "Próximos pasos:"
echo "  - Realiza las migraciones necesarias sobre la base de datos, deberían estar en el directorio data_wrangling/ "
echo "  - Ejecuta el script permissions.sh para ajustar los permisos sobre los archivos del proyecto Symfony."
