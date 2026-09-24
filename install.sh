#!/usr/bin/env bash

# ===========================================
# Script de despliegue para Symfony (prod)
# Fedora 41 / 42 + Apache
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
git config --system --add safe.directory "$APP_ROOT" 2>/dev/null || git config --global --add safe.directory "$APP_ROOT"
git checkout master

echo "Crear directorios var y uploads si no existen…"
[ ! -d "$VAR_DIR" ] && mkdir -p "$VAR_DIR"
[ ! -d "$UPLOADS_DIR" ] && mkdir -p "$UPLOADS_DIR"

echo "Habilitando entorno de producción…"
export APP_ENV=prod
export COMPOSER_ALLOW_SUPERUSER=1

echo "Instalando dependencias Composer…"
composer install --no-dev --optimize-autoloader --no-interaction
composer dump-env prod

echo "Ejecutando migraciones Doctrine…"
php bin/console doctrine:migrations:migrate --no-interaction

echo "Inicializando datos de usuarios en base de datos SQLite…"
if [ -f "$GIT_ROOT/Databases/SQLite/user.sql" ]; then
    sqlite3 "$VAR_DIR/data_prod.db" ".read $GIT_ROOT/Databases/SQLite/user.sql" 2>/dev/null || true
    cp "$VAR_DIR/data_prod.db" "$VAR_DIR/data_dev.db" 2>/dev/null || true
fi

echo "Instalando framework Gob.mx…"
php bin/console app:gob-mx

echo "Limpiando y regenerando cache…"
php bin/console cache:clear --env=prod
php bin/console cache:warmup --env=prod

echo "Cargando assets e importmap…"
php bin/console importmap:install
php bin/console asset-map:compile
php bin/console error:dump var/cache/prod/error_pages/ 403 404 500 502 503

# ==========================================
# Setup SELinux + permisos para Symfony
# Fedora / Apache / PHP-FPM
# ==========================================

echo "Corrigiendo permisos…"
chown -R "$HTTPD_USER:$HTTPD_USER" "$APP_ROOT"
chmod -R 775 "$VAR_DIR"
chmod -R 775 "$UPLOADS_DIR"

echo "Aplicando contexto SELinux de lectura…"
semanage fcontext -a -t httpd_sys_content_t "$APP_ROOT(/.*)?" 2>/dev/null
restorecon -Rv "$APP_ROOT"

echo "Aplicando contexto SELinux de escritura para var/…"
semanage fcontext -a -t httpd_sys_rw_content_t "$VAR_DIR(/.*)?" 2>/dev/null
restorecon -Rv "$VAR_DIR"

echo "Aplicando contexto SELinux de escritura para uploads/…"
semanage fcontext -a -t httpd_sys_rw_content_t "$UPLOADS_DIR(/.*)?" 2>/dev/null
restorecon -Rv "$UPLOADS_DIR"

echo "Activando booleanos SELinux…"
setsebool -P httpd_can_network_connect on

echo "Instalando servicios…"
cd "$GIT_ROOT" || exit 1
if [ -d "/etc/systemd/system" ]; then
    cp services/symfony-messenger.service /etc/systemd/system/symfony-messenger.service 2>/dev/null || true
    cp services/symfony-scheduler.service /etc/systemd/system/symfony-scheduler.service 2>/dev/null || true

    systemctl daemon-reload 2>/dev/null || true
    systemctl enable --now symfony-messenger.service 2>/dev/null || true
    systemctl enable --now symfony-scheduler.service 2>/dev/null || true

    echo "Reiniciando servicios…"
    systemctl restart httpd 2>/dev/null || true
    systemctl restart symfony-messenger 2>/dev/null || true
    systemctl restart symfony-scheduler 2>/dev/null || true
fi

echo
echo "CONFIGURACIÓN COMPLETA"
echo "Symfony ahora tiene permisos correctos con SELinux habilitado."
echo
echo "Puedes verificar con:"
echo "  ls -Z $APP_ROOT"
echo "  ls -Z $VAR_DIR"
echo
echo "Contextos esperados:"
echo "  Código:  httpd_sys_content_t"
echo "  Escritura: httpd_sys_rw_content_t"
