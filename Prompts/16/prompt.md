Roles Users and registration

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

Hay un control de acceso a usuarios a nivel del controlador ilustrado en la siguiente tabla de permisos, en los métodos indicados en la primera columna.

|        |      Patient     |    Appointment   |    Attendance    |      Visitor     | User             |
|:------:|:----------------:|:----------------:|:----------------:|:----------------:|------------------|
|  index |     ROLE_USER    |     ROLE_USER    |     ROLE_USER    |     ROLE_USER    | ROLE_ADMIN       |
|  show  |     ROLE_USER    |     ROLE_USER    |     ROLE_USER    |     ROLE_USER    | ROLE_USER        |
|   new  |    ROLE_ADMIN    |    ROLE_ADMIN    |     ROLE_USER    |     ROLE_USER    | -                |
|  edit  |    ROLE_ADMIN    |    ROLE_ADMIN    |     ROLE_USER    |     ROLE_USER    | ROLE_USER        |
| delete | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN |

Implementa las siguientes condiciones:

1. Los usuarios ROLE_USER solo podrán ver la ruta app_user_show cuando se trate de su propio id. No podrán ver la ruta si el id es diferente. Los usuarios ROLE_ADMIN y ROLE_SUPER_ADMIN no tienen restricciones.
2. La ruta app_register solo podrá accederse con el nivel ROLE_ADMIN con las siguientes condiciones:
- Si el usuario es ROLE_ADMIN, en el campo `roles` solo se mostrarán las opciones "'User' => 'ROLE_USER'" y "'Admin' => 'ROLE_ADMIN'".
- Si el usuario es ROLE_SUPER_ADMIN, también se mostrará la opción "'Super Admin' => 'ROLE_SUPER_ADMIN'"
3. Los usuarios ROLE_USER solo podrán ver la ruta app_user_edit cuando se trate de su propio id. No podrán ver la ruta si el id es diferente. Además, en el compo `roles` solo podrán ver la opción "'User' => 'ROLE_USER'".
4. Los usuarios ROLE_ADMIN no podrán ver la ruta app_user_edit cuando el id a modificar tenga el rol de ROLE_SUPER_ADMIN. Ademáś, en el campo `roles` solo se mostrarán las opciones "'User' => 'ROLE_USER'" y "'Admin' => 'ROLE_ADMIN'".

La documentación sobre seguridad de Symfony está en el siguiente enlace: https://symfony.com/doc/current/security.html

Si surge algún error, notifica inmediatamente, con una captura de pantalla, así podré darte instrucciones.

Muéstrame imágenes de cada uno de los templates modificados.

***

Con los cambios hechos en la ruta app_user_edit se encuentra la condición:

```
if ($this->isGranted('ROLE_ADMIN') && in_array('ROLE_SUPER_ADMIN', $user->getRoles(), true)) {
            throw $this->createAccessDeniedException();
}
```

La cual impide que ROLE_ADMIN modifique a un usuario ROLE_SUPER_ADMIN, lo cual es correcto. Sin embargo, hay usuarios que tendrán ambos roles, por lo que si dicho usuario tiene ambos roles, si debe permitir el acceso. Ejemplo:

User1 tiene rol ROLE_ADMIN, User2 tiene rol ROLE_SUPER_ADMIN y User3 tiene roles ROLE_ADMIN y ROLE_SUPER_ADMIN.

User1 no puede ir a app_user_edit de User2 o User3. User2 y User3 si pueden ir a app_user_edit de todos los perfiles. 
