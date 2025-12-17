# Rotate files

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

Este sistema guarda archivos en la carpeta `public/uploads`. Actualmente habrá dos directorios de imágenes: `visitor` y `attendance`. A su vez, estos directorios se van a dividir por fecha, por lo tanto existirán: `public/uploads/visitor/{year}/{month}` y `public/uploads/attendance/{year}/{month}` donde `year` y `month` son dos variables numéricas que corresponden al año y mes, por ejemplo: `public/uploads/visitor/2025/12/` corresponde a las imágenes de diciembre del año 2025. Dentro, habrá multiples imágenes PNG, por ejemplo: 22-20251203083033.png, 55-20251219083033.png

Lo que necesito es que crees un Comando que se llame `CompressImageCommand`, el cual debe comprimir la imágenes que tengan 12 meses de existencia. Por ejemplo: si existe la carpeta visitor de Febrero de 2024 (`public/uploads/visitor/2024/02/`) con los archivos 22-20251203083033.png, 55-20251219083033.png, y la fecha actual indica que es Febrero del año 2025, el comando va a comprimir las imágenes, por lo que el directorio `public/uploads/visitor/2024/02/` contendrá los archivos 22-20251203083033.png.gz y 55-20251219083033.png.gz

Una vez pasados dos años, es decir, si la fecha actual es Febrero del año 2026, el comando va a comprimir la carpeta completa del mes. Por lo tanto, en lugar de existir `public/uploads/visitor/2024/02/`, va existir el archvio `public/uploads/visitor/2024/02.tar.gz`

Pasados tres años, es decir, si la fecha actual es Febrero del año 2027, se borrará el archivo `public/uploads/visitor/2024/02.tar.gz`.

Finalmente, si hay un directorio de año vacío, es decir, si `public/uploads/visitor/2024` es un directorio vacío, debe ser borrado.

Podrías escribir el comando `CompressImageCommand` por mí.
