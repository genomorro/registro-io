# Virtual Host

Tengo un sitio web sobre Apache. El sitio web usa Symfony Framework y está configurado de la siguiente manera:
```
# /etc/apache2/conf.d/testing.iner.gob.mx.conf
<VirtualHost *:80>
  ServerName testing.iner.gob.mx
  ServerAlias www.testing.iner.gob.mx

  Redirect permanent / https://testing.iner.gob.mx
</VirtualHost>

<VirtualHost *:443>
    ServerName testing.iner.gob.mx
    ServerAlias www.testing.iner.gob.mx

    # Uncomment the following line to force Apache to pass the Authorization
    # header to PHP: required for "basic_auth" under PHP-FPM and FastCGI
    #
    # SetEnvIfNoCase ^Authorization$ "(.+)" HTTP_AUTHORIZATION=$1

    <FilesMatch \.php$>
        # when using PHP-FPM as a unix socket
        SetHandler proxy:unix:/run/php-fpm/www.sock|fcgi://dummy

        # when PHP-FPM is configured to use TCP
        # SetHandler proxy:fcgi://127.0.0.1:9000
    </FilesMatch>

    DocumentRoot /var/www/testing/public_html/public
    <Directory /var/www/testing/public_html/public>
        AllowOverride None
        Require all granted
        FallbackResource /index.php
    </Directory>

    # uncomment the following lines if you install assets as symlinks
    # or run into problems when compiling LESS/Sass/CoffeeScript assets
    # <Directory /var/www/testing/public_html/public>
    #     Options FollowSymlinks
    # </Directory>

    # optionally disable the fallback resource for the asset directories
    # which will allow Apache to return a 404 error when files are
    # not found instead of passing the request to Symfony
    # <Directory /var/www/testing/public_html/public/bundles>
    #     DirectoryIndex disabled
    #     FallbackResource disabled
    # </Directory>

    ErrorLog /var/log/httpd/testing_error.log
    CustomLog /var/log/httpd/testing_access.log combined

    SSLEngine on
    SSLCertificateFile /etc/httpd/ssl/2026-testing.iner.gob.mx.cert.pem
    SSLCertificateKeyFile /etc/httpd/ssl/2026-testing.iner.gob.mx.key.pem
    SSLCertificateChainFile /etc/httpd/ssl/ca.cert.pem

</VirtualHost>
```
En el mismo servidor tengo una instancia de Metabase, cuyo virtual host está escrito de la siguiente manera:
```
<VirtualHost *:80>

    ServerName metabase.iner.gob.mx

    ProxyPreserveHost On

    ProxyPass / http://127.0.0.1:3000/
    ProxyPassReverse / http://127.0.0.1:3000/

    RequestHeader set X-Forwarded-Proto "http"

    ErrorLog /var/log/httpd/metabase_iner_gob_mx_error.log
    CustomLog /var/log/httpd/metabase_iner_gob_mx_access.log combined

</VirtualHost>
```
Esta instancia de Metabase funciona como un servicio dentro del Sistema Operativo, el guión de inicio es el siguiente:
```
[Unit]
Description=Metabase server
After=network.target

[Service]
WorkingDirectory=/home/metabase
ExecStart=/usr/bin/java --add-opens java.base/java.nio=ALL-UNNAMED -jar /home/metabase/metabase.jar
# EnvironmentFile=/home/metabase/.env
User=metabase
Type=simple
SuccessExitStatus=143
TimeoutStopSec=120
Restart=always

[Install]
WantedBy=multi-user.target
```
Como puedes ver actualmente:

1. Mi sistema Symfony se accede por: testing.iner.gob.mx
2. Mi sistema Metabase se accede por: metabase.iner.gob.mx

Quiero que a partir de ahora, metabase se acceda por medio de una subruta, y ya no mediante un dominio. Quiero que quede así:

1. Mi sistema Symfony se accede por: testing.iner.gob.mx
2. Mi sistema Metabase se acceda por: testing.iner.gob.mx/metabase

Por favor dime los pasos que debo seguir para lograrlo.


****

Aquí tienes la guía detallada paso a paso para realizar esta migración y lograr que Metabase se acceda mediante la subruta /metabase en tu dominio testing.iner.gob.mx.

Consideración Técnica Importante
Metabase necesita saber explícitamente cuál es su URL base (Site URL) para poder construir correctamente las rutas absolutas de sus archivos estáticos (CSS, JS, imágenes), llamadas API y enlaces en correos electrónicos. Si no configuramos esto, Metabase intentará buscar los recursos en la raíz (/), lo que provocará errores 404 en la consola del navegador y una pantalla en blanco.

Paso 1: Configurar la URL Base (Site URL) en Metabase
Hay dos formas de indicarle a Metabase su nueva URL. Elige una de las siguientes opciones:

Opción A: Mediante Variable de Entorno (Recomendada y más limpia)
Dado que usas un archivo de servicio de Systemd, podemos aprovechar la variable de entorno MB_SITE_URL.

Abre o crea tu archivo de entorno /home/metabase/.env (puedes descomentar la línea # EnvironmentFile=/home/metabase/.env de tu unidad Systemd si aún no lo has hecho):
MB_SITE_URL=https://testing.iner.gob.mx/metabase
Alternativamente, puedes definirla directamente dentro de la sección [Service] de tu archivo de servicio Systemd /etc/systemd/system/metabase.service usando la directiva Environment:
[Service]
WorkingDirectory=/home/metabase
ExecStart=/usr/bin/java --add-opens java.base/java.nio=ALL-UNNAMED -jar /home/metabase/metabase.jar
Environment="MB_SITE_URL=https://testing.iner.gob.mx/metabase"
User=metabase
Type=simple
SuccessExitStatus=143
TimeoutStopSec=120
Restart=always
Opción B: A través del Panel de Administración de Metabase (Antes de apagar el dominio viejo)
Si tu dominio metabase.iner.gob.mx aún está activo y accesible:

Inicia sesión en Metabase como Administrador.
Ve a Admin > Settings (Configuración) > General.
Busca el campo Site URL y cámbialo a: https://testing.iner.gob.mx/metabase
Guarda los cambios.
Paso 2: Modificar la configuración de Apache para Symfony (testing.iner.gob.mx)
Debes editar el archivo de configuración del VirtualHost del sistema Symfony para agregar las directivas de proxy inverso (Reverse Proxy) bajo la ruta /metabase.

Abre el archivo de configuración de Apache (por ejemplo, /etc/apache2/conf.d/testing.iner.gob.mx.conf o /etc/httpd/conf.d/testing.iner.gob.mx.conf) y edita el bloque <VirtualHost *:443> de la siguiente manera:

<VirtualHost *:443>
    ServerName testing.iner.gob.mx
    ServerAlias www.testing.iner.gob.mx

    # ... (Manten tus directivas existentes intactas, como FilesMatch de PHP-FPM, DocumentRoot, etc.)

    DocumentRoot /var/www/testing/public_html/public
    <Directory /var/www/testing/public_html/public>
        AllowOverride None
        Require all granted
        FallbackResource /index.php
    </Directory>

    # ==========================================
    # CONFIGURACIÓN DEL PROXY PARA METABASE
    # ==========================================
    # 1. Indicamos a Apache que NO use el FallbackResource de Symfony para la ruta /metabase
    <Location /metabase>
        FallbackResource disabled
    </Location>

    # 2. Configuramos el Proxy Reverso hacia el puerto interno 3000
    ProxyPreserveHost On
    
    # Es muy importante el orden y el manejo de las barras diagonales (/)
    ProxyPass /metabase http://127.0.0.1:3000
    ProxyPassReverse /metabase http://127.0.0.1:3000

    # 3. Encabezados necesarios para que Metabase reconozca HTTPS y las IPs correctas
    RequestHeader set X-Forwarded-Proto "https"
    RequestHeader set X-Forwarded-Port "443"

    # ==========================================

    ErrorLog /var/log/httpd/testing_error.log
    CustomLog /var/log/httpd/testing_access.log combined

    SSLEngine on
    SSLCertificateFile /etc/httpd/ssl/2026-testing.iner.gob.mx.cert.pem
    SSLCertificateKeyFile /etc/httpd/ssl/2026-testing.iner.gob.mx.key.pem
    SSLCertificateChainFile /etc/httpd/ssl/ca.cert.pem
</VirtualHost>
¿Por qué agregamos <Location /metabase> FallbackResource disabled </Location>?
Symfony utiliza FallbackResource /index.php para redirigir todas las peticiones de rutas inexistentes en el sistema de archivos al controlador frontal de Symfony. Si no deshabilitamos el fallback para /metabase, Apache podría intentar pasar las solicitudes destinadas a Metabase a Symfony, resultando en un error 404 de Symfony.

Paso 3: Deshabilitar o Eliminar el Virtual Host antiguo de Metabase
Para evitar conflictos de nombres de dominio y limpiar la configuración de tu Apache:

Elimina (o mueve a un directorio de respaldo/respaldos) el archivo del Virtual Host de metabase.iner.gob.mx:
# Ejemplo si está en conf.d
mv /etc/httpd/conf.d/metabase.iner.gob.mx.conf /etc/httpd/conf.d/metabase.iner.gob.mx.conf.bak
(Si estás usando Debian/Ubuntu con a2ensite/a2dissite, simplemente ejecuta a2dissite metabase.iner.gob.mx).
Paso 4: Aplicar cambios y reiniciar servicios
Para que todos los cambios surtan efecto de manera limpia y segura, ejecuta los siguientes comandos en tu servidor:

Recargar la configuración de systemd (si editaste el archivo del servicio de Metabase):

sudo systemctl daemon-reload
Reiniciar el servicio de Metabase:

sudo systemctl restart metabase
Verificar la sintaxis de Apache antes de reiniciar para asegurarte de que no haya errores que puedan tumbar el servidor web:

sudo apachectl configtest
# O en algunos sistemas:
sudo apache2ctl configtest
(Deberías ver un mensaje que diga Syntax OK).

Reiniciar Apache:

sudo systemctl restart httpd
# O en sistemas Debian/Ubuntu:
sudo systemctl restart apache2
Paso 5: Verificación
Ingresa a tu navegador e intenta acceder a: https://testing.iner.gob.mx/metabase
Abre las Herramientas de Desarrollador del navegador (F12) y ve a la pestaña Console (Consola) y Network (Red) para asegurarte de que todos los archivos .js y .css de Metabase carguen correctamente desde la subruta /metabase/app/... con código de estado HTTP 200 OK (y no 404 Not Found).
¡Eso es todo! Con estos pasos, tu sistema Symfony continuará funcionando en la raíz, y Metabase responderá de manera fluida y segura a través de la subruta bajo HTTPS. Si tienes alguna duda sobre algún paso, estaré encantado de ayudarte.
