# Reports

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

Actualmente existen seis entidades: Stakeholder, Patient, Hospitalized, Visitor, Appointment y Attendance, cada una tiene sus templates CRUD creados. También hay una entidad User para control de usuarios. La jerarquía de permisos es la siguiente (no incluye aun Stakeholder), de menos permisos a más permisos: ROLE_USER, ROLE_ADMIN, ROLE_SUPER_ADMIN

Hay un control de acceso a usuarios a nivel del controlador ilustrado en la siguiente tabla de permisos, en los métodos indicados en la primera columna.

|        | Patient/Hospitalized | Appointment      | Attendance       | Visitor          | User             |
| index  | ROLE_USER            | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_ADMIN       |
| show   | ROLE_USER            | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_USER        |
| new    | ROLE_ADMIN           | ROLE_ADMIN       | ROLE_USER        | ROLE_USER        | ROLE_ADMIN       |
| edit   | ROLE_ADMIN           | ROLE_ADMIN       | ROLE_USER        | ROLE_USER        | ROLE_USER        |
| delete | ROLE_SUPER_ADMIN     | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN |

Ya existe la integración de reportes con KoolReport. Actualmente existe un reporte `PatientTodayReport`.

Quiero que crees el siguiente reporte:

- De cada User relacionar con las entidades Attendance, Visitor y Stakeholder por medio de los valores de Check in y Check out. Es decir, quiero saber cuantos check in y check out ha hecho un User en cada una de estas entidades durante el día de hoy y en total.

***

Crea otro reporte que permita:

- Saber cuantos Attendance, Visitor y Stakeholder hay durante el día actual por hora, considera dos cosas, la hora de Check in y la hora de Check out.
- Saber cuantos Attendance, Visitor y Stakeholder hay en promedio históricamente, para saber a que hora suele haber más registros, considera dos cosas, la hora de Check in y la hora de Check out.
- Grafica los datos por medio de un AreaChart los datos.

***

Gracias a la tabla puedo ver que no es preciso el reporte, espero lo siguiente representado en la tabla y desde ahí construir el gráfico:

- Suponga que entre las 12:00 y 13:00 hubo en Attendance 3 check in y 5 check out. El valor de Attendance en ese lapso de tiempo es 8.
- Luego, suponga que entre las 13:00 y las 14:00 Hay en Attendance 2 check in y 1 check out. El valor entonces será de 3, no se suman los 8 del periodo anterior.

Este comportamiento aplica para las 3 entidades, en el gráfico del día actual y en el histórico.
