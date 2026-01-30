# Analyze Gob.mx

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

La aplicación usa el framework Gob.mx. Este framework se carga desde un CDN, por lo que no puedo modificarlo. Se carga desde las líneas 14, 15 y 28 del template `base.html.twig`. Ese framework, carga bootstrap 5.3.3 desde el archivo gobmx.js

Esto provoca que múltiples instancias de Bootstrap sean cargadas, ya que AssetMapper lo carga para que funcione UX-Autocomplete. Esto causa conflictos con algunos eventos como `data-bs-toggle` que causa fallas aleatorias al expandir y colapsar menús.

Será posible hacer funcionar el sitio, especialmente UX-Autocomplete evitando conflictos de bibliotecas con el framework Gob.mx.

Mi solución ideal sería:

1. Crea un comando llamado `app:gob-mx`
2. Al ser llamado, el comando descarga el archivo `gobmx.js` y lo coloca en assets/vendor/gobmx
3. Modifica el archivo `gobmx.js` para que no cargue Bootstrap
4. Se carga el framework Gob.mx desde el archivo modificado.

***

El menú de la aplicación está definido en el template `menu.html.twig`. Este menú está completo pero tiene un problema: de forma aleatoria, en el menú responsivo una vez que se despliega, no se vuelve a compactar. De forma similar, si tuviera una opción Dropdown, de forma aleatoria, al presionar, no se despliega. Esto puede deberse al uso del framework Gob.mx. He descargado los tres archivos básicos de este framework en la carpeta `assets/style`: main.css, main.js gobmx.js

Quiero que hagas dos tareas:

1. Examina el código del framework Gob.mx y trata de encontrar que interfiere con el menú, si son reglas CSS puedes escribirlas en un archivo aparte, si se trata de JavaScript, escribe un controlador Stimulus que corrija el problema. No es posible corregir el framework Gob.mx directamente, porque se carga directamente en línea.
2. Identifica el código relacionado con el menú, elementos, funciones, reglas, etc. Para que pueda examinarlo manualmente. Puedes crear archivos nuevos, que aislen estos códigos.

***

Necesito que hagas una tarea más por mí. Quiero instalar Tempus Dominus via AssetMapper:
``
php bin/console importmap:require @eonasdan/tempus-dominus
```
Luego crear un StimulusController, como el siguiente:
```
import { Controller } from "@hotwired/stimulus"

import { TempusDominus } from "@eonasdan/tempus-dominus"
tempusDominus.extend( window.tempusDominus.plugins.customDateFormat );

export default class extends Controller {
  connect() {
    new tempusDominus.TempusDominus( this.element, {
      localization: {
         format: 'yyyy-MM-dd HH:mm'
      },
      display: {
        inline: true,
        sideBySide: true,
        buttons: {
          clear: false,
          close: false
        },
        calendarWeeks: true,
        components: {
          clock: true,
          useTwentyfourHour: true
        },
      },    
      useCurrent: false
    });
  }
}
```
Quiero que este controlador funcione en la ruta `app_stakeholder_new` cuando se active el campo correspondiente al Check In.

Si logras hacerlo, muéstrame una imagen con este cambio funcionando.
