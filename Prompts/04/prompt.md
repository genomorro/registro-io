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

Primero, en la entidad Visitor, vas a cambiar el tipo de dato de phone, deberá ser varchar y no int como ahora mismo.

Modificarás el template de templates/visitor/index.html.twig para que se muestre el name de los Patient que visitarán.

Modificarás el template templates/visitor/show.html.twig para que muestre el name y el file de los Patient relacionados. 

En los templates templates/visitor/show.html.twig y templates/visitor/index.html.twig, en los campos de CheckOutAt, si no tiene un valor, debe aparecer un botón que al presionarlo registra en la base de datos la hora en la que se presiona dicho botón en el campo CheckOutAt.

En el formulario creación de un Visitor, no debe solicitarse el CheckInAt, debido a que siempre será la hora actual en la que se crea el registro, pero debes tener cuidado de no modificar el formulario de edición.

En el template template/patient/show.html.twig debe aparecer una sección con la lista de Visitor que tienen un CheckInAt del día de hoy. 

Muéstrame imágenes de cada uno de los templates modificados.
