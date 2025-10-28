API

Este es un proyecto de Synfony 7.3, requiere instalar PHP 8.4 y MariaDB 11 o SQLite3 como base de datos. Los datos de conexión a la base de datos puedes colocarlos en el archivo .env agregando una línea como: 

	DATABASE_URL="mysql://db_user:db_password@127.0.0.1:3306/db_name?serverVersion=10.5.8-MariaDB"

Ejemplo:

	DATABASE_URL="mysql://registro-io:registro-io.passwd@127.0.0.1:3306/registro-io?serverVersion=11.8.3-MariaDB-0+deb13u1+from+Debian"

Para SQLite3 lo correcto es:

	DATABASE_URL="sqlite:///%kernel.project_dir%/var/data_%kernel.environment%.db"

Para incorporar cambios en la base de datos:

	php bin/console make:migration php bin/console doctrine:migrations:migrate

Todas las consultas a la base de datos que sean necesarias deben ser creadas con DQL, pues el proyecto usa Doctrine, y deben ser declaradas en los archivos que se encuentran en el directorio src/Repository/

Se puede iniciar un servidor de prueba con la instrucción:

	symfony server:start

Para tener el comando symfony en Docker se puede agregar al Dockerfile:

	COPY --link
	--from=ghcr.io/symfony-cli/symfony-cli:latest
	/usr/local/bin/symfony /usr/local/bin/symfony

Luego, se accede por medio de la dirección http://localhost:8000

Los controladores de cada entidad se encuentran en src/Controller/, ellos envían la información con la cual se forman los templates. Los formularios se crean según los archivos localizados en src/Form/

Actualmente existen cuatro entidades, Patient, Visitor, Appointment y Attendance, cada una tiene sus templates CRUD creados. También hay una entidad User para control de usuarios. La jerarquía de permisos es la siguiente, de menos permisos a más permisos: ROLE_USER, ROLE_ADMIN, ROLE_SUPER_ADMIN

Hay un control de acceso a usuarios a nivel del controlador ilustrado en la siguiente tabla de permisos, en los métodos indicados en la primera columna.

| Patient | Appointment      | Attendance       | Visitor          | User             |                  |
| index   | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_ADMIN       |
| show    | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_USER        |
| new     | ROLE_ADMIN       | ROLE_ADMIN       | ROLE_USER        | ROLE_USER        |                  |
| edit    | ROLE_ADMIN       | ROLE_ADMIN       | ROLE_USER        | ROLE_USER        | ROLE_USER        |
| delete  | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN |

El sistema está completo y funcional, solo necesito que se implemente un API REST para los método de las entidades que existen en el sistema, en otras palabras, crear el API REST de la aplicación completa.. Las rutas del sistema actualmente tienen una estructura como esta: /appointment corresponde a app_appointment_index; /attendance/new corresponde a app_attendance_new. En el caso del API, las rutas tendrán la siguiente forma: /api/appointment corresponde a api_appointment_index; /api/attendance/new corresponde a api_attendance_new.

Hay entidades que tienen relaciones muchos a muchos, no olvides serializar las consultas para evitar consultas circulares. 

Muéstrame imágenes de las consultas json generadas.
