# Embedding Metabase

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

Actualmente existen ocho entidades consolidadas: Stakeholder, Patient, Hospitalized, Visitor, Appointment, Attendance, Area, Employee, cada una tiene sus templates CRUD creados. También hay una entidad User para control de usuarios. La jerarquía de permisos es la siguiente (no incluye aun Stakeholder), de menos permisos a más permisos: ROLE_USER, ROLE_ADMIN, ROLE_SUPER_ADMIN

Hay un control de acceso a usuarios a nivel del controlador ilustrado en la siguiente tabla de permisos, en los métodos indicados en la primera columna.

|        | Patient/Hospitalized | Appointment      | Attendance       | Visitor          | User             | Area             | Employee         |
| index  | ROLE_USER            | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_ADMIN       | ROLE_USER        | ROLE_USER        |
| show   | ROLE_USER            | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_ADMIN       | ROLE_ADMIN       |
| new    | ROLE_ADMIN           | ROLE_ADMIN       | ROLE_USER        | ROLE_USER        | ROLE_ADMIN       | ROLE_USER        | ROLE_USER        |
| edit   | ROLE_ADMIN           | ROLE_ADMIN       | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_ADMIN       | ROLE_ADMIN       |
| delete | ROLE_SUPER_ADMIN     | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN |

El sistema tiene un apartado de reportes, mediante la biblioteca koolreport. Estos reportes son generados en ReportController.php. La ruta app_report_index actualmente es una página fija para seleccionar los distintos reportes.

Actualmente estoy probando Metabase para generar mejores reportes, y me da la opción de incrustar resultados en un sitio HTML. Metabase me ofrece el siguiente código:

```
<script defer src="https://accesos.iner.gob.mx/metabase/app/embed.js"></script>
<script>
function defineMetabaseConfig(config) {
  window.metabaseConfig = config;
}
</script>

<script>
  defineMetabaseConfig({
    "theme": {
      "preset": "light"
    },
    "isGuest": true,
    "instanceUrl": "https://accesos.iner.gob.mx/metabase"
  });
</script>

<!--
THIS IS THE EXAMPLE!
NEVER HARDCODE THIS JWT TOKEN DIRECTLY IN YOUR HTML!

Fetch the JWT token from your backend and programmatically pass it to the 'metabase-dashboard'.
-->
<metabase-dashboard token="eyJhbGciOiJIUzI1NiJ9.eyJyZXNvdXJjZSI6eyJkYXNoYm9hcmQiOjJ9LCJwYXJhbXMiOnt9LCJpYXQiOjE3ODY2MzYwOTIsImV4cCI6MTc4NjYzNjY5MiwiX2VtYmVkZGluZ19wYXJhbXMiOnt9fQ.pRkbzu9qYB8psAawcF0R5_NfGaFf38HTMm1OkIluVaU" with-title="true" with-downloads="true"></metabase-dashboard>
```

También me ofrece un código de autenticación:

```
// you will need to install via 'npm install jsonwebtoken' or in your package.json

const jwt = require("jsonwebtoken");


const METABASE_SECRET_KEY = "e49c45b18a09b030b159b7c3b8727e9b6b4c2556b732d340545ba2c81c12e720";

const payload = {
  resource: { dashboard: 2 },
  params: {},
  exp: Math.round(Date.now() / 1000) + (10 * 60) // 10 minute expiration
};
const token = jwt.sign(payload, METABASE_SECRET_KEY);
```

Quiero que sustituyas el código del template app_report_index para incrustar el reporte de Metabase y saber si es viable dejar de usar Koolreport. 

Considera lo siguiente:

1. No podrás acceder a https://accesos.iner.gob.mx/metabase porque está disponible desde internet. Por lo que seré yo quien te confirmará manualmente si ha funcionado.
2. Instala las dependencias necesarias y crea los controladores Stimulus necesarios para el código javascript.
