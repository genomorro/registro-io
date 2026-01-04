# Stakeholder WebRTC

Este es un proyecto de Synfony 7.4, requiere instalar PHP 8.4 y MariaDB 11 o SQLite3 como base de datos. Los datos de conexión a la base de datos puedes colocarlos en el archivo `.env` agregando una línea como: 
```.env
DATABASE_URL="mysql://db_user:db_password@127.0.0.1:3306/db_name?serverVersion=10.5.8-MariaDB"
```
Ejemplo:
```.env
DATABASE_URL="mysql://registro-io:registro-io.passwd@127.0.0.1:3306/registro-io?serverVersion=11.8.3-MariaDB-0+deb13u1+from+Debian"
```
Para SQLite3 lo correcto es:
```
DATABASE_URL="sqlite:///%kernel.project_dir%/var/data_%kernel.environment%.db"
```
Para incorporar cambios en la base de datos:
```bash
php bin/console make:migration
php bin/console doctrine:migrations:migrate
```
Como la aplicación tiene control de acceso, la base de datos debe tener al menos un registro en la tabla User, mismo que debe ser usado para ingresar al sistema.

También pueden ser necesarios los siguientes comandos si una pantalla tiene problemas al cargar:
Se deben cargar los assets manualmente:
```bash
php bin/console asset-map:compile
```
```bash
bin/console cache:clear
```
Todas las consultas a la base de datos que sean necesarias deben ser creadas con DQL, pues el proyecto usa Doctrine, y deben ser declaradas en los archivos que se encuentran en el directorio src/Repository/

Se puede iniciar un servidor de prueba con la instrucción:
```bash
symfony server:start
```
Para tener el comando symfony en Docker se puede agregar al Dockerfile:
```
COPY --link
	--from=ghcr.io/symfony-cli/symfony-cli:latest
	/usr/local/bin/symfony /usr/local/bin/symfony
```
Luego, se accede por medio de la dirección http://localhost:8000

Los controladores de cada entidad se encuentran en src/Controller/, ellos envían la información con la cual se forman los templates. Los formularios se crean según los archivos localizados en src/Form/. Los commando se encuentran en src/Command.

Actualmente existen cinco entidades, Patient, Hospitalized, Visitor, Appointment y Attendance, cada una tiene sus templates CRUD creados. También hay una entidad User para control de usuarios. La jerarquía de permisos es la siguiente, de menos permisos a más permisos: ROLE_USER, ROLE_ADMIN, ROLE_SUPER_ADMIN

Hay un control de acceso a usuarios a nivel del controlador ilustrado en la siguiente tabla de permisos, en los métodos indicados en la primera columna.

|         | Patient/Hospitalized  | Appointment      | Attendance       | Visitor          | User             |
| index   | ROLE_USER             | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_ADMIN       |
| show    | ROLE_USER             | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_USER        |
| new     | ROLE_ADMIN            | ROLE_ADMIN       | ROLE_USER        | ROLE_USER        |                  |
| edit    | ROLE_ADMIN            | ROLE_ADMIN       | ROLE_USER        | ROLE_USER        | ROLE_USER        |
| delete  | ROLE_SUPER_ADMIN      | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN |

Se acaba de crear una nueva entidad, Stakeholder. Existe su controlador, su formulario y sus templates.

Quiero que se hagan los siguientes cambios:

1. En esta nueva entidad hay un campo evidence, que debe usar el controlador Stimulus de WebRTC. Debe estar habilitado para tomar fotos, y funcionar exactamente igual a como funciona este campo en las entidades Visitor (`app_visitor_new`) y Attendance (`app_attendance_new`)
2. En la ruta `app_stakeholder_show` debe mostrarse la imagen de evidence, igual a como se muestra en Visitor y Attendance.
3. La ruta para guardar imágenes será "public/uploads/stakeholder", con subcarpetas divididas por año, y mes. Nombre del archivo con el 'id' y la fecha.
4. Actualiza el commando commpress-image para que también sea procesada por este comando.
