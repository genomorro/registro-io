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

Actualmente existen tres entidades, Patient, Appointment y Attendance, cada una tiene sus templates CRUD creados.

Modifica esos templates, para que en templates/patient/index.html.twig aparezcan dos columnas más. La primera columna será "Check in", la cual mostrará un botón con el cual se creará un Attendance nuevo cuyo checkin_at será la fecha y hora en la que se presionó el botón, y estará relacionada con el Patient correspondiente. Si el Attendance ya existe, no se mostrará el botón, se mostrará el valor de checkin_at correspondiente al Attendance ya existente que está relacionado con el Patient. La segunda columna será "Check out", la cual mostrará un botón con el cual se escribirá el valor de checkout_at del Attendance relacionado con el Patient. En este caso ya debe existir un Attendance relacionado con el Patient, de otra manera el botón debe estar deshabilitado.

En templates/patient/show.html.twig debe aparecer la información del Attendance del día de hoy, si es que existe.

En templates/attendance/index.html.twig debe aparecer también la propiedad name de la entidad Patient.

Muéstrame imágenes de cada uno de los templates modificados.


***

En template/attendance/index.html.twig es posible implementar en la columna Checkout_at la funcionalidad de botón, la cual mostrará un botón con el cual se escribirá el valor de checkout_at del Attendance relacionado con el Patient.
