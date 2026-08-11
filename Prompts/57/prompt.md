# INTEGRACIÓN AREA Y EMPLOYEE

Este es un proyecto de Synfony 7.4, requiere instalar PHP 8.4 y MariaDB 11 o SQLite3 como base de datos. Se usan dos comandos php principalmente, composer y symfony. Los datos de conexión a la base de datos puedes colocarlos en el archivo `.env` agregando una línea como:
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

Actualmente existen seis entidades consolidadas: Stakeholder, Patient, Hospitalized, Visitor, Appointment y Attendance, cada una tiene sus templates CRUD creados. También hay una entidad User para control de usuarios. La jerarquía de permisos es la siguiente (no incluye aun Stakeholder), de menos permisos a más permisos: ROLE_USER, ROLE_ADMIN, ROLE_SUPER_ADMIN

Hay un control de acceso a usuarios a nivel del controlador ilustrado en la siguiente tabla de permisos, en los métodos indicados en la primera columna.

|        | Patient/Hospitalized | Appointment      | Attendance       | Visitor          | User             |
| index  | ROLE_USER            | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_ADMIN       |
| show   | ROLE_USER            | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_USER        |
| new    | ROLE_ADMIN           | ROLE_ADMIN       | ROLE_USER        | ROLE_USER        | ROLE_ADMIN       |
| edit   | ROLE_ADMIN           | ROLE_ADMIN       | ROLE_USER        | ROLE_USER        | ROLE_USER        |
| delete | ROLE_SUPER_ADMIN     | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN |

Acabo de crear dos nuevas entidades: Area y Employee. Estas están relacionadas, un Area tiene tres campos, building, unit y extension, building es un valor númerico. Tengo en el archivo ~src/Forms/AreaAutocompleteField.php~ el siguiente estracto de código:
```
		return sprintf(
		    '(%s) %s',
		    $area->getBuilding(),
		    $area->getUnit());
	    },

```
Mismo que hoy día coloca entre paréntesis el número de building y el nombre de la unit. Quiero cambiar esa cadena por:
```
		return sprintf(
		    'Building %s - %s',
		    $area->getBuilding(),
		    $area->getUnit());
	    },

```
Mi problema es que no se como hacer que la palabra "Building" sea traducida mediante Symfony\Contracts\Translation\TranslatorInterface. Podrías ejecutar ese cambio por mí.

Después, modifica la ruta `app_employee_index` para que la tabla muestre una columna con el Area del Employee. La columna debe tener el mismo formato "Building - Unit". Además cada valor, debe ser un enlace a `app_area_show` correspondiente.

***

Muy bien, podrías hacer que en `app_employee_show` se muestre también el Area relacionada al Employee. Mismo formato de cadena "Building - Unit" y con el enlace correspondiente.
