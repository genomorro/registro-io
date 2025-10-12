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

Modifica esos templates, para que en templates/appointment/show.html.twig aparezca el name y el file del Patient relacionado. En templates/attendance/show.html.twig debe aparecer el name y el file del Patient relacionado, además, implementar de mostrar un botón al mostrar el el Checkout_At. Si Checkout_At no tiene un valor, se mostrará este botón con el cual se escribirá el valor al tiempo actual del Checkout_At del Attendance relacionado con el Patient. 

Muéstrame imágenes de cada uno de los templates modificados.
