Search by file with validation

Este es un proyecto de Synfony 7.3, requiere instalar PHP 8.4 y MariaDB 11 o SQLite3 como base de datos. Los datos de conexión a la base de datos puedes colocarlos en el archivo .env agregando una línea como:
	DATABASE_URL="mysql://db_user:db_password@127.0.0.1:3306/db_name?serverVersion=10.5.8-MariaDB"

Ejemplo:

	DATABASE_URL="mysql://registro-io:registro-io.passwd@127.0.0.1:3306/registro-io?serverVersion=11.8.3-MariaDB-0+deb13u1+from+Debian"

Para SQLite3 lo correcto es:

	DATABASE_URL="sqlite:///%kernel.project_dir%/var/data_%kernel.environment%.db"

Para incorporar cambios en la base de datos:

	php bin/console make:migration  --formatted
	php bin/console doctrine:migrations:migrate

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

Implementa una controlador llamado Search.php, con un formulario SearchType.php y su respectivo template. Este controlador es para hacer búsquedas. Aquí dejo una tabla con ejemplos de cadenas almacenadas en la base de datos:

|000255220|
|000654312|
|IAN341294|
|000891092|
|IAN232132|
|000554623|
|IAN255220|

Observa que solo los primeros tres caracteres pueden ser letras, estas letras serán 'IAN'. El formulario pedirá una cadena de entre 6 a 9 caracteres, si la cadena inicia con 'IAN' deberá ser de 9 caracteres. Si la cadena son solo números puede ser de 6 a 9 caracteres.

Si busco '255220' o '000255220' el resultado de la búsqueda debe ser el registro '000255220', si busco 'IAN255220' encontraré 'IAN255220'.

El formulario busca en la propiedad file de la entidad Patient. Como resultado debe redireccionar a la ruta app_patient_show que corresponda con el file buscado. La búsqueda siempre regresa un solo resultado.

Si surge algún error, notifica inmediatamente, con una captura de pantalla, así podré darte instrucciones.

Muéstrame imágenes de cada uno de los templates modificados.
