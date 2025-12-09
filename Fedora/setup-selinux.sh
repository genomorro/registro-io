#!/usr/bin/env bash

# ==========================================
# Setup SELinux + permisos para Symfony
# Fedora 41 / Apache / PHP-FPM
# ==========================================

APP_ROOT="/var/www/registro-io/public_html"
VAR_DIR="$APP_ROOT/var"
UPLOADS_DIR="$APP_ROOT/public/uploads"

echo "Configurando Symfony en:"
echo "  APP_ROOT:   $APP_ROOT"
echo "  VAR_DIR:    $VAR_DIR"
echo "  UPLOADS_DIR:$UPLOADS_DIR"
echo

# ============================
# 1. Validar rutas
# ============================
if [ ! -d "$APP_ROOT" ]; then
    echo "❌ ERROR: El directorio $APP_ROOT no existe."
    exit 1
fi

# Crear var/ y uploads/ si no existen
[ ! -d "$VAR_DIR" ] && mkdir -p "$VAR_DIR"
[ ! -d "$UPLOADS_DIR" ] && mkdir -p "$UPLOADS_DIR"

# ============================
# 2. Permisos Unix
# ============================
echo "Ajustando permisos Unix..."
chown -R apache:apache "$APP_ROOT"
chmod -R 775 "$VAR_DIR"
chmod -R 775 "$UPLOADS_DIR"

# ============================
# 3. SELinux: permitir lectura de todo el proyecto
# ============================
echo "Aplicando contexto SELinux de lectura..."
semanage fcontext -a -t httpd_sys_content_t "$APP_ROOT(/.*)?" 2>/dev/null
restorecon -Rv "$APP_ROOT"

# ============================
# 4. SELinux: permitir escritura solo en var/ y uploads/
# ============================
echo "Aplicando contexto SELinux de escritura para var/…"
semanage fcontext -a -t httpd_sys_rw_content_t "$VAR_DIR(/.*)?" 2>/dev/null
restorecon -Rv "$VAR_DIR"

echo "Aplicando contexto SELinux de escritura para uploads/…"
semanage fcontext -a -t httpd_sys_rw_content_t "$UPLOADS_DIR(/.*)?" 2>/dev/null
restorecon -Rv "$UPLOADS_DIR"

# ============================
# 5. SELinux: permitir a Apache usar la red (útil para API, composer, etc.)
# ============================
echo "Activando booleanos SELinux…"
setsebool -P httpd_can_network_connect on

# (Solo si tu app usa DB externa, NO SQLite)
setsebool -P httpd_can_network_connect_db on

# ============================
# 6. Finalización
# ============================
echo
echo "✅ CONFIGURACIÓN COMPLETA"
echo "Symfony ahora tiene permisos correctos con SELinux habilitado."
echo
echo "Puedes verificar con:"
echo "  ls -Z $APP_ROOT"
echo "  ls -Z $VAR_DIR"
echo
echo "Contextos esperados:"
echo "  Código:  httpd_sys_content_t"
echo "  Escritura: httpd_sys_rw_content_t"
