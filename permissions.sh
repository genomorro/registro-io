#!/usr/bin/env bash

# ==========================================
# Setup SELinux + permisos para Symfony
# Fedora 41 / Apache / PHP-FPM
# ==========================================

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

echo "Crear directorios var y uploads si no existen…"
[ ! -d "$VAR_DIR" ] && mkdir -p "$VAR_DIR"
[ ! -d "$UPLOADS_DIR" ] && mkdir -p "$UPLOADS_DIR"

echo "Corrigiendo permisos…"
sudo chown -R apache:apache "$APP_ROOT"
sudo chmod -R 775 "$VAR_DIR"
sudo chmod -R 775 "$UPLOADS_DIR"

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
cp services/symfony-messenger.service /etc/systemd/system/symfony-messenger.service
cp services/symfony-scheduler.service /etc/systemd/system/symfony-scheduler.service

systemctl daemon-reload
systemctl enable --now symfony-messenger.service
systemctl enable --now symfony-scheduler.service

echo "Reiniciando servicios…"
systemctl restart httpd
systemctl restart symfony-messenger
systemctl restart symfony-scheduler

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
