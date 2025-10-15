Autocomplete

Este es un proyecto de Synfony 6.4, requiere instalar PHP 8.4 y MariaDB 11. Los datos de conexión a la base de datos puedes colocarlos en el archivo .env agregando una línea como:

	DATABASE_URL="mysql://db_user:db_password@127.0.0.1:3306/db_name?serverVersion=10.5.8-MariaDB"

Ejemplo:

	DATABASE_URL="mysql://registro-io:registro-io.passwd@127.0.0.1:3306/registro-io?serverVersion=11.8.3-MariaDB-0+deb13u1+from+Debian"

Todas las consultas a la base de datos que sean necesarias deben ser creadas con DQL, pues el proyecto usa Doctrine, y deben ser declaradas en los archivos que se encuentran en el directorio src/Repository/

Se puede iniciar un servidor de prueba con la instrucción:

	symfony server:start

Para tener el comando symfony en Docker se puede agregar al Dockerfile:

	COPY --link \
    --from=ghcr.io/symfony-cli/symfony-cli:latest \
    /usr/local/bin/symfony /usr/local/bin/symfony

Luego, se accede por medio de la dirección http://localhost:8000

Los controladores de cada entidad se encuentran en src/Controller/, ellos envían la información con la cual se forman los templates. Los formularios se crean según los archivos localizados en src/Form/ 

Actualmente existen cuatro entidades, Patient, Visitor, Appointment y Attendance, cada una tiene sus templates CRUD creados.

Existe un bundle de Symfony llamado ux-autocomplete, el cual facilita la búsqueda en un select. Necesito implementar esa característica en para los siguientes campos:

1. En la entidad Appointment, formulario de las rutas app_appointment_new y app_appointment_edit, en el campo Patient.
2. En la entidad Attendance, formulario de las rutas app_attendance_new y app_attendance_edit, en el campo Patient.
3. En la entidad Visitor, formulario de las rutas app_visitor_new y app_visitor_edit, en el campo Patient. Adicionalmente, este campo no tener required="required" debido a que puede estar vacío.

La página de documentación de autocomplete, con eso puedes aprender como implementarlo: https://symfony.com/bundles/ux-autocomplete/current/index.html
autocomplete está estrechamente relacionado con Stimulus, así que revísalo también: https://symfony.com/bundles/StimulusBundle/current/index.html

Sobre posibles problemas, puedes revisar:
- https://stackoverflow.com/questions/74261525/why-is-symfony-ux-autocomplete-not-working-here
- https://stackoverflow.com/questions/74184248/new-symfony-ux-live-components-work-but-arent-updated-interactively

Si surge algún error, notifica inmediatamente, con una captura de pantalla, así podré darte instrucciones.

Muéstrame imágenes de cada uno de los templates modificados.


***

DateTimePicker

Este es un proyecto de Synfony 6.4, requiere instalar PHP 8.4 y MariaDB 11. Los datos de conexión a la base de datos puedes colocarlos en el archivo .env agregando una línea como:

	DATABASE_URL="mysql://db_user:db_password@127.0.0.1:3306/db_name?serverVersion=10.5.8-MariaDB"

Ejemplo:

	DATABASE_URL="mysql://registro-io:registro-io.passwd@127.0.0.1:3306/registro-io?serverVersion=11.8.3-MariaDB-0+deb13u1+from+Debian"

Todas las consultas a la base de datos que sean necesarias deben ser creadas con DQL, pues el proyecto usa Doctrine, y deben ser declaradas en los archivos que se encuentran en el directorio src/Repository/

Se puede iniciar un servidor de prueba con la instrucción:

	symfony server:start

Para tener el comando symfony en Docker se puede agregar al Dockerfile:

	COPY --link \
    --from=ghcr.io/symfony-cli/symfony-cli:latest \
    /usr/local/bin/symfony /usr/local/bin/symfony

Luego, se accede por medio de la dirección http://localhost:8000

Los controladores de cada entidad se encuentran en src/Controller/, ellos envían la información con la cual se forman los templates. Los formularios se crean según los archivos localizados en src/Form/ 

Actualmente existen cuatro entidades, Patient, Visitor, Appointment y Attendance, cada una tiene sus templates CRUD creados.

Existe el bundle yaroslavche/symfony-ux-flatpickr, del cual instala Flatpickr dentro de Symfony y su sitio web es: https://github.com/yaroslavche/symfony-ux-flatpickr

En la aplicación existen los formularios de Appointment, Attendance y Visitor, los cuales tienen campos de CheckIn, CheckOut y DateAt. Todos ellos requieren fecha y hora, por lo pido que implementes el bundle para la selección de los valores en estas propiedades.

Si surge algún error, notifica inmediatamente, con una captura de pantalla, así podré darte instrucciones.

Muéstrame imágenes de cada uno de los templates modificados.
