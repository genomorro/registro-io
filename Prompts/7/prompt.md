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

En los formularios de edición de Attendance y Visitor, el campo de CheckOut tienen de forma predeterminada la fecha y hora actuales. Sin embargo, eso solo debe aplicarse si el valor de CheckOut está vacío, de otra manera debe conservar el valor actual.

Crea un diagrama entidad-relación de la base de datos actual.

Finalmente, crea un conjunto de cien datos de prueba, en SQL, para MariaDB. En la tabla patient, file es un número que inicia con tres ceros y luego 6 números más, por ejemplo: 000255220. En la tabla appointment, los types serán: Estudio, Consulta, Procedimiento. Los place serán: Consultorio 1 al 28, Clínica de sueño, Hospital de día. En visitor, los valores de dni serán: INE, Cartilla militar y Licencia de conducir. Mientras que relationship serán: Padre, Madre, Tío, Hermano, Sobrino, Abuelo, Nieto, Otro.

Muéstrame imágenes de cada uno de los templates modificados.
