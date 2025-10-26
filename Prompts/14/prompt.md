Roles 4 Entities

Este es un proyecto de Synfony 7.3, requiere instalar PHP 8.4 y MariaDB 11 o SQLite3 como base de datos. Los datos de conexión a la base de datos puedes colocarlos en el archivo .env agregando una línea como:
	DATABASE_URL="mysql://db_user:db_password@127.0.0.1:3306/db_name?serverVersion=10.5.8-MariaDB"

Ejemplo:

	DATABASE_URL="mysql://registro-io:registro-io.passwd@127.0.0.1:3306/registro-io?serverVersion=11.8.3-MariaDB-0+deb13u1+from+Debian"

Para SQLite3 lo correcto es:

	DATABASE_URL="sqlite:///%kernel.project_dir%/var/data_%kernel.environment%.db"

Para incorporar cambios en la base de datos:

	php bin/console make:migration
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

Actualmente existen cuatro entidades, Patient, Visitor, Appointment y Attendance, cada una tiene sus templates CRUD creados. También hay una entidad User para control de usuarios. La jerarquía de permisos es la siguiente, de menos permisos a más permisos: ROLE_USER, ROLE_ADMIN, ROLE_SUPER_ADMIN

Implementarás a nivel del controlador la siguiente tabla de permisos, en los métodos indicados en la primera columna.

|        |      Patient     |    Appointment   |    Attendance    |      Visitor     | User             |
|:------:|:----------------:|:----------------:|:----------------:|:----------------:|------------------|
|  index |     ROLE_USER    |     ROLE_USER    |     ROLE_USER    |     ROLE_USER    | ROLE_ADMIN       |
|  show  |     ROLE_USER    |     ROLE_USER    |     ROLE_USER    |     ROLE_USER    | ROLE_USER        |
|   new  |    ROLE_ADMIN    |    ROLE_ADMIN    |     ROLE_USER    |     ROLE_USER    | -                |
|  edit  |    ROLE_ADMIN    |    ROLE_ADMIN    |     ROLE_USER    |     ROLE_USER    | ROLE_USER        |
| delete | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN |

La documentación sobre seguridad de Symfony está en el siguiente enlace: https://symfony.com/doc/current/security.html

Si surge algún error, notifica inmediatamente, con una captura de pantalla, así podré darte instrucciones.

Muéstrame imágenes de cada uno de los templates modificados.

***

Parece que es correcto el funcionamiento hasta el momento. Ajusta el archivo menu.html.twig, existe el siguiente código:

```
		<li class="nav-item dropdown">
		    <a class="nav-link subnav-link dropdown-toggle"
		       href="#"
		       id="navbarDropdown"
		       role="button"
		       data-bs-toggle="dropdown"
		       aria-expanded="false">
			{% trans %}User{% endtrans %}
		    </a>
		    <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
			<li><a class="dropdown-item" href="{{ path('app_login') }}">{% trans %}Log in{% endtrans %}</a></li>
			<li><a class="dropdown-item" href="{{ path('app_logout') }}">{% trans %}Log out{% endtrans %}</a></li>
			<li><hr class="dropdown-divider"></li>
			<li><a class="dropdown-item" href="{{ path('app_user_index') }}">{% trans %}User index{% endtrans %}</a></li>
		    </ul>
		</li>
```
El elemento `<li><a class="dropdown-item" href="{{ path('app_login') }}">{% trans %}Log in{% endtrans %}</a></li>` solo debe aparecer si no hay una sesión de usuario iniciada. El elemento `<li><a class="dropdown-item" href="{{ path('app_logout') }}">{% trans %}Log out{% endtrans %}</a></li>` solo debe aparecer si hay una sesión de usuario iniciada. El elemento `<li><a class="dropdown-item" href="{{ path('app_user_index') }}">{% trans %}User index{% endtrans %}</a></li>` solo debe aparecer si el rol de usuario es ROLE_ADMIN. 

Además, agrega otra opción en ese menú, que se llame "Perfil" que solo aparecerá si hay una sesión de usuario. Esa opción llevará a la ruta app_user_show del usuario actual.

Finalmente, verifica el funcionamiento de las opciones dropdown de menu.html.twig, debido a que hay ocasiones en las cuales no se despliega al hacer click en la opción, en este momento se soluciona recargando la página, pero no debería ocurrir y no se sabe la causa.
