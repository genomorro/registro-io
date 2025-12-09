#!/usr/bin/env bash

# ===========================================
# Script de despliegue para Symfony (prod)
# Fedora 41 + Apache + SELinux
# ===========================================

APP_ROOT="/var/www/registro-io/public_html"

echo "Despliegue Symfony iniciado…"
cd "$APP_ROOT" || exit 1

echo "Instalando dependencias Composer…"
composer install --no-dev --optimize-autoloader --no-interaction

echo "Ejecutando migraciones Doctrine…"
php bin/console make:migration --no-interaction
php bin/console doctrine:migrations:migrate --no-interaction

echo "Limpiando y regenerando cache…"
php bin/console cache:clear --env=prod
php bin/console cache:warmup --env=prod

echo "Corrigiendo permisos…"
chown -R apache:apache var
chmod -R 775 var

echo "Aplicando SELinux…"
semanage fcontext -a -t httpd_sys_rw_content_t "$APP_ROOT/public/var(/.*)?" 2>/dev/null
restorecon -Rv "$APP_ROOT/public/var"

echo "Reiniciando servicios…"
systemctl restart httpd
systemctl restart symfony-messenger

echo "Despliegue completado correctamente."
