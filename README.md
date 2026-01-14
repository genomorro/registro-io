# registro-io
Sistema de registro de entrada y salida para los pacientes del INER y sus familiares, ya sean acompañantes o visitas.

## Requisitos
Al consultar se debe mostrar todo aquello agendado para el día actual únicamente.

Se debe registrar cuando un familiar pasa al instituto, por lo que se debe ligar con el paciente, y cada paciente debe tener dos posibles familiares asociados a la vez.

Cada familiar debe tener un número de gafete, será posible buscar al familiar por número de gafete, cada familiar debe tener:

- Nombre del familiar
- Parentesco
- Número de gafete
- Destino
- Teléfono
- Hora de entrada
- Hora de salida

## Datos requeridos del ECE
1. Número de expediente
2. Nombre del paciente
3. Fecha y hora de la cita
4. Especialidad de la cita
5. Si la cita es por consulta, estudios o procedimiento
6. Lugar de realización

Con esto se permitirá el ingreso al instituto.

## ACL

Actualmente existen cuatro entidades, Patient, Visitor, Appointment y Attendance, cada una tiene sus templates CRUD creados. También hay una entidad User para control de usuarios. La jerarquía de permisos es la siguiente, de menos permisos a más permisos: ROLE_USER, ROLE_ADMIN, ROLE_SUPER_ADMIN

Hay un control de acceso a usuarios a nivel del controlador ilustrado en la siguiente tabla de permisos, en los métodos indicados en la primera columna.

|        | Appointment      | Attendance       | Patient          | Visitor          | User             |
|--------|------------------|------------------|------------------|------------------|------------------|
| index  | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_ADMIN       |
| new    | ROLE_SUPER_ADMIN | ROLE_USER        | ROLE_SUPER_ADMIN | ROLE_USER        | ROLE_ADMIN       |
| show   | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_USER        |
| edit   | ROLE_SUPER_ADMIN | ROLE_USER        | ROLE_SUPER_ADMIN | ROLE_USER        | ROLE_USER        |
| delete | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN |

En los templates, el control de acceso indica si un botón aparece o no para un usuario, de tal forma que puede ver la ruta.

|        | Appointment      | Attendance       | Patient          | Visitor          | User             |
|--------|------------------|------------------|------------------|------------------|------------------|
| index  | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_ADMIN       |
| new    | ROLE_SUPER_ADMIN | ROLE_USER        | ROLE_SUPER_ADMIN | ROLE_USER        | ROLE_ADMIN       |
| show   | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_USER        |
| edit   | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_USER        |
| delete | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN |

## Diagrama entidad-relación
![Diagrama entidad-relación](DER.png)

## Development
El sistema esta elaborado en Symfony 7.4 LTS:
```bash
  Version              7.4.2
  Long-Term Support    Yes
  End of maintenance   11/2028 (in +1086 days)
  End of life          11/2029 (in +1451 days)
```
El código fuente está disponible en [Gitlab](https://gitlab.com/genomorro/registro-io-code.git)

### Git
Clonar el proyecto de manera habitual, luego cargar el submódulo:
```bash
git submodule init
git submodule update
```
Si se trabaja desde Gitlab, funcionará el espejo hacia Github. Pero si se decide trabajar desde Github, es necesario agregar Gitlab como origen y posteriormente sincronizar de forma manual:
```bash
git remote add origin2 https://gitlab.com/genomorro/registro-io.git
git branch -M main
git remote -v
git push -uf origin2 main
```
No olvidar que Github maneja como rama principal _master_ y Gitlab es _main_.

***

Symfony se instaló con el siguiente comando:
```bash
symfony new public_html --version=lts --webapp
```
Para iniciar el web server de desarrollo:
```bash
symfony server:start
```	
Estará disponible por medio del [navegador web](http://localhost:8000)

Se crearon las entidades con 
```bash
php bin/console make:entity
```	
Para incorporar cambios en la base de datos:
```bash
php bin/console make:migration
php bin/console doctrine:migrations:migrate
```
Luego el CRUD, el cual si crea archivos adicionales:
```bash
php bin/console make:crud
The class name of the entity to create CRUD (e.g. TinyGnome):
> Paciente

Choose a name for your controller class (e.g. PacienteController) [PacienteController]:
> 

Do you want to generate PHPUnit tests? [Experimental] (yes/no) [no]:
> 
	
created: src/Controller/PacienteController.php
created: src/Form/PacienteType.php
created: templates/paciente/_delete_form.html.twig
created: templates/paciente/_form.html.twig
created: templates/paciente/edit.html.twig
created: templates/paciente/index.html.twig
created: templates/paciente/new.html.twig
created: templates/paciente/show.html.twig


Success! 


Next: Check your new CRUD by going to /paciente/
```
**Todas las consultas a la base de datos que sean necesarias deben ser creadas con DQL**, pues el proyecto usa Doctrine, y deben ser declaradas en los archivos que se encuentran en el directorio `src/Repository/`

Para tener el comando `symfony` en Docker se puede agregar al Dockerfile:
```docker
COPY --link \
    --from=ghcr.io/symfony-cli/symfony-cli:latest \
    /usr/local/bin/symfony /usr/local/bin/symfony
```

### Base de datos
Existe un archivo SQL que carga usuarios para entrar en el sistema [MySQL/MariaDB](./Databases/MySQL/data.sql) y [SQLite3](./Databases/SQLite/data.sql). Es posible ejecutarlo como normalmente se hace con cualquier archivo SQL:
```bash
sqlite3 public_html/var/data_dev.db ".read Databases/SQLite/data.sql"
```
También hay dos archivos CSV generados automáticamente en `data_wragling/out`. Para cargarlos en SQLite3:

```bash
SQLite version 3.50.4 2025-07-30 19:33:53
Enter ".help" for usage hints.
sqlite> .mode csv
sqlite> .import -skip 1 data_wrangling/out/patient.csv patient
data_wrangling/out/patient.csv:71790: INSERT failed: UNIQUE constraint failed: patient.id
data_wrangling/out/patient.csv:111791: INSERT failed: UNIQUE constraint failed: patient.id
data_wrangling/out/patient.csv:131999: INSERT failed: UNIQUE constraint failed: patient.id
data_wrangling/out/patient.csv:149241: INSERT failed: UNIQUE constraint failed: patient.id
data_wrangling/out/patient.csv:150266: INSERT failed: UNIQUE constraint failed: patient.id
data_wrangling/out/patient.csv:150639: INSERT failed: UNIQUE constraint failed: patient.id
sqlite> .import -skip 1 data_wrangling/out/appointment.csv appointment
sqlite> .quit
```
En el ejemplo se observan errores de importación, para una base de datos en producción, estos errores no deben existir.

## Instalación
Al descargar los repositorios, lo primero es entrar en `public_html` y ejecutar:
```bash
composer install
```
Si se usa Apache como Web Server, se debe instalar apache-pack:
```bash
composer require symfony/apache-pack
```
Se deben cargar los assets manualmente:
```bash
php bin/console asset-map:compile
```
Si las páginas de error no se muestran, se pueden cargar manualmente (los números pueden omitirse):
```bash
APP_ENV=prod php bin/console error:dump var/cache/prod/error_pages/ 403 404 500 502 503
```
Este es un proyecto de Symfony 7.4, requiere instalar PHP 8.4 y MariaDB 11 o SQLite3. Los datos de conexión a la base de datos puedes colocarlos en el archivo `.env` agregando una línea como:
```.env
DATABASE_URL="mysql://db_user:db_password@127.0.0.1:3306/db_name?serverVersion=10.5.8-MariaDB"
```
Ejemplo:
```.env
DATABASE_URL="mysql://registro-io:registro-io.passwd@127.0.0.1:3306/registro-io?serverVersion=11.8.3-MariaDB-0+deb13u1+from+Debian"
```
Para SQLite3 lo correcto es:
```.env
DATABASE_URL="sqlite:///%kernel.project_dir%/var/data_%kernel.environment%.db"
```
Si se requiere solo un usuario y una base de datos limpia, puede ingresarse directamente la siguiente información en la base de datos:

| Atributo | Valor                      | Base de datos                                                |
|----------|----------------------------|--------------------------------------------------------------|
| Id       | 1                          | 1                                                            |
| username | iner                       | iner                                                         |
| roles    | ROLE_SUPER_ADMIN           | ["ROLE_USER","ROLE_SUPER_ADMIN","ROLE_ADMIN"]                |
| password | 00552281                   | $2y$13$QC8jjTPtDTApjMAKgpsWcejNXdsGYvFL.iadTBEO9PiIM.i1eol86 |
| name     | Coordinación de sistemas   | Coordinación de sistemas                                     |

Se han generado [archivos sql para distintas bases de datos](./Databases) ese propósito.

Otros parámetros del archivo `.env` que se deben modificar son:
```.env
###> symfony/framework-bundle ###
APP_ENV=prod
APP_SECRET=io.iner.gob.mx-secret
###< symfony/framework-bundle ###
###> symfony/routing ###
# Configure how to generate URLs in non-HTTP contexts, such as CLI commands.
# See https://symfony.com/doc/current/routing.html#generating-urls-in-commands
DEFAULT_URI=https://accesos.iner.gob.mx
###< symfony/routing ###
###> symfony/mailer ###
MAILER_DSN=null://null
###< symfony/mailer ###
```
Si después de una configuración adecuada se obtiene el sitio en entorno `dev` pero no en `prod`, hay que limpiar el caché:
```bash
bin/console cache:clear
```
También será útil el log de error si el problema persiste: `var/cache/log/prod.log`.

En algunos entornos con SELinux activado, hay que ajustar los permisos como dice en [la documentación de Symfony](https://symfony.com/doc/current/setup/file_permissions.html)
y después si es necesario:
```bash
chcon -R -t httpd_sys_content_rw_t /var/www/
```
### Servicios
La aplicación necesita que se instale un servicio de forma permanente, con el fin de mantener sincronizada la base de datos y rotar los archivos subidos a la aplicación. El guion de inicio para Systemd está disponible en el archivo [symfony-scheduler.service](./services/symfony-scheduler.service)
### Web server
Los ejemplos, asumen que el dominio será [accesos.iner.gob.mx](accesos.iner.gob.mx), que el socket de PHP se ubica en `/var/run/php/php-fpm.sock` y que la carpeta del proyecto será `/var/www/registro-io/public_html/public`.

```Apache2
# /etc/apache2/conf.d/accesos.iner.gob.mx.conf
<VirtualHost *:80>
    ServerName accesos.iner.gob.mx
    ServerAlias www.accesos.iner.gob.mx

    # Uncomment the following line to force Apache to pass the Authorization
    # header to PHP: required for "basic_auth" under PHP-FPM and FastCGI
    #
    # SetEnvIfNoCase ^Authorization$ "(.+)" HTTP_AUTHORIZATION=$1

    <FilesMatch \.php$>
        # when using PHP-FPM as a unix socket
        SetHandler proxy:unix:/var/run/php/php-fpm.sock|fcgi://dummy

        # when PHP-FPM is configured to use TCP
        # SetHandler proxy:fcgi://127.0.0.1:9000
    </FilesMatch>

    DocumentRoot /var/www/registro-io/public_html/public
    <Directory /var/www/registro-io/public_html/public>
        AllowOverride None
        Require all granted
        FallbackResource /index.php
    </Directory>

    # uncomment the following lines if you install assets as symlinks
    # or run into problems when compiling LESS/Sass/CoffeeScript assets
    # <Directory /var/www/registro-io/public_html/public>
    #     Options FollowSymlinks
    # </Directory>

    # optionally disable the fallback resource for the asset directories
    # which will allow Apache to return a 404 error when files are
    # not found instead of passing the request to Symfony
    # <Directory /var/www/registro-io/public_html/public/bundles>
    #     DirectoryIndex disabled
    #     FallbackResource disabled
    # </Directory>

    ErrorLog /var/log/apache2/accesos_error.log
    CustomLog /var/log/apache2/accesos_access.log combined
</VirtualHost>
```
```Nginx
# /etc/nginx/conf.d/accesos.iner.gob.mx.conf
server {
    server_name accesos.iner.gob.mx www.io.iner.gob.mx;
    root /var/www/registro-io/public_html/public;

    location / {
        # try to serve file directly, fallback to index.php
        try_files $uri /index.php$is_args$args;
    }

    # optionally disable falling back to PHP script for the asset directories;
    # nginx will return a 404 error when files are not found instead of passing the
    # request to Symfony (improves performance but Symfony's 404 page is not displayed)
    # location /bundles {
    #     try_files $uri =404;
    # }

    location ~ ^/index\.php(/|$) {
        # when using PHP-FPM as a unix socket
        fastcgi_pass unix:/var/run/php/php-fpm.sock;

        # when PHP-FPM is configured to use TCP
        # fastcgi_pass 127.0.0.1:9000;

        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;

        # optionally set the value of the environment variables used in the application
        # fastcgi_param APP_ENV prod;
        # fastcgi_param APP_SECRET <app-secret-id>;
        # fastcgi_param DATABASE_URL "mysql://db_user:db_pass@host:3306/db_name";

        # When you are using symlinks to link the document root to the
        # current version of your application, you should pass the real
        # application path instead of the path to the symlink to PHP
        # FPM.
        # Otherwise, PHP's OPcache may not properly detect changes to
        # your PHP files (see https://github.com/zendtech/ZendOptimizerPlus/issues/126
        # for more information).
        # Caveat: When PHP-FPM is hosted on a different machine from nginx
        #         $realpath_root may not resolve as you expect! In this case try using
        #         $document_root instead.
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT $realpath_root;
        # Prevents URIs that include the front controller. This will 404:
        # http://io.iner.gob.mx/index.php/some-path
        # Remove the internal directive to allow URIs like this
        internal;
    }

    # return 404 for all other php files not matching the front controller
    # this prevents access to other php files you don't want to be accessible.
    location ~ \.php$ {
        return 404;
    }

    error_log /var/log/nginx/io_error.log;
    access_log /var/log/nginx/io_access.log;
}
```
## Respaldo
Los archivos y directorios a respaldar son las carpetas dentro de `public/uploads` que contienen las imágenes del sistema y si la base de datos es SQLite3, también deben guardarse los archivos con extensión `.db` ubicados en la carpeta `var/`.

## Comandos

Existen cuatro comandos dentro del sistema que sirven para hacer tareas de mantenimiento.

1. Sincronización con el Expediente Clínico Electrónico:
```
symfony console app:import-data
```
Este comando, de hecho, ejecuta tres comandos, `app:import-data:patient`, `app:import-data:appointment`, `app:import-data:hospitalized`.

2. Rotación de archivos creados por el sistema
```
symfony console app:compress-image
```

## Roadmap
- [X] Crear la entidad Patient
- [X] Crear la entidad Appointment
- [X] En el index de Patient solo deben aparecer los pacientes con cita el día de hoy 
- [X] En el show de Patient debe aparecer la lista de citas, dividida en dos, las citas del día de hoy y otras citas
- [X] En el index de Appointment debe aparecer el nombre del paciente
- [X] En show de Appointment debe aparecer el nombre y número de expediente del paciente
- [X] Crear la entidad Attendance
- [X] En el index de Patient debe aparecer la información de Attendance
- [X] En el index de Patient se creará/actualizará el Attendance por medio de botones
- [X] En el show de Patient debe aparecer la información del Attendance del día de hoy
- [X] En el index de Attendance debe aparecer el nombre del paciente
- [X] En el index de Attendance debe actualizarse el checkout_at por medio de un botón
- [X] En el show de Attendance debe actualizarse el checkout_at por medio de un botón
- [X] En el show de Attendance debe aparecer el nombre y número de expediente del paciente 
- [X] Crear la entidad Visitor
- [X] En el index de Visitor debe aparecer el nombre del paciente relacionado
- [X] En el show de Patient debe aparecer la lista de visitantes, en la parte superior el visitante más reciente
- [X] En el index de Visitor debe actualizarse el checkout_at por medio de un botón
- [X] El día y la hora predeterminada de los formularios con CheckIn, Attendance y Visitor, deben ser la fecha y hora actuales
- [X] En los formularios de edición, la fecha y hora de CheckOut debe ser la fecha y hora actuales
- [X] Cada Attendance debe tener una propiedad tag
- [X] Implementar hoja de estilo de Gob.mx
- [X] Implementar paginación
- [x] Unificar estilos en formularios
- [X] Búsqueda de Patient por número de expediente
- [X] Búsqueda de Visitor y Patient por tag
- [X] Implementar niveles de usuario
- [X] Traducir la aplicación
- [X] Implementar páginas de error
- [ ] Implementar un API REST (GET), para alimentar los datos
- [X] Reimplementar Botones CheckOut en Attendance
- [X] Crear la entidad Hospitalized
- [X] Identificar pacientes hospitalizados: Servicio y cama
- [X] Agregar documento probatorio a Visitor y Attendance
- [X] Rotar archivos históricos en `public/upload`
- [X] Crear comandos para sincronizar base de datos
- [X] Crear servicios cron
- [X] Relacionar la entidad User con checkInAt y checkOutAt de Visitor y Attendance
- [x] Mostrar la relación User-check in/out según corresponda
- [x] Crear la entidad Stakeholder
- [x] Adaptar a dispositivos móviles como opción. Puede haber múltiples cámaras
- [x] Implementar firma autógrafa
- [ ] Revisar UI de las vistas Hospitalized y Stakeholder
- [ ] Implementar una interfaz que relacione una tablet con la firma autógrafa
- [ ] Implementar modo de mantenimiento
- [ ] Implementar solo actualización al importar datos para no bloquear la base de datos SQLite3
- [ ] Corregir instalación en Apache bajo Fedora u otros GNU/Linux
- [ ] Implementar flash messages para notificación de errores básicos de la aplicación
- [ ] Crear un Dockerfile
- [-] Implementar un menú eficiente

Solicitudes de DTIC
- [X] Ocultar el id
- [X] Un appointment debe tener como propiedad: Especialidad, estado (Agendada, cancelada)
- [X] El type de appointment debe ser PRIMERA VEZ, SUBSECUENTE, ESTUDIO, PROCEDIMIENTO
- [X] Refinar tablas de índice
- [X] Reordenar app_patient_show: Citas hoy, Asistencia hoy
- [X] Cambiar 'Lugar' con 'Agenda'
- [X] Un appointment debe tener como propiedad: Ubicación
- [X] En Otras Citas, solo mostrar citas futuras
- [X] Unificar los formularios de Búsqueda
- [X] Un solo formulario de búsqueda por gafete
- [X] El menú de ROLE_USER debe reducirse: Inicio, Buscar, Visitantes
- [-] Validar hora de la cita con hora de ingreso, turno matutino y vespertino
- [-] Validar hora de la cita con hora de ingreso, por cercanía de hora de la cita
- [-] Usar dos bases de datos

## Soporte y contribuciones
Si planeas contribuir a este proyecto, por favor usa el repositorio [registro-io](https://gitlab.com/genomorro/registro-io) para cualquier tipo de documentación, usa [registro-io-code](https://gitlab.com/genomorro/registro-io-code) para contribución de código fuente. Cualquier error o bug sobre el código, debe ser reportado en [registro-io-code](https://gitlab.com/genomorro/registro-io-code/-/issues).

## Licencia
This repo is part of Registro de I/O INER 

Copyright (C) 2025, Edgar Uriel Domínguez Espinoza

Registro de I/O INER is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

Registro de I/O INER is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Registro de I/O INER; if not, see http://www.gnu.org/licenses/ or write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
