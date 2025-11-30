# Busqueda por nombre

Este es un proyecto de Synfony 7.3, requiere instalar PHP 8.4 y MariaDB 11 o SQLite3 como base de datos. Los datos de conexión a la base de datos puedes colocarlos en el archivo `.env` agregando una línea como: 
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
```
symfony server:start
```
Para tener el comando symfony en Docker se puede agregar al Dockerfile:
```
COPY --link
	--from=ghcr.io/symfony-cli/symfony-cli:latest
	/usr/local/bin/symfony /usr/local/bin/symfony
```
Luego, se accede por medio de la dirección http://localhost:8000

Los controladores de cada entidad se encuentran en src/Controller/, ellos envían la información con la cual se forman los templates. Los formularios se crean según los archivos localizados en src/Form/

Actualmente existen cuatro entidades, Patient, Visitor, Appointment y Attendance, cada una tiene sus templates CRUD creados. También hay una entidad User para control de usuarios. La jerarquía de permisos es la siguiente, de menos permisos a más permisos: ROLE_USER, ROLE_ADMIN, ROLE_SUPER_ADMIN

Hay un control de acceso a usuarios a nivel del controlador ilustrado en la siguiente tabla de permisos, en los métodos indicados en la primera columna.

| Patient | Appointment      | Attendance       | Visitor          | User             |                  |
| index   | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_ADMIN       |
| show    | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_USER        |
| new     | ROLE_ADMIN       | ROLE_ADMIN       | ROLE_USER        | ROLE_USER        |                  |
| edit    | ROLE_ADMIN       | ROLE_ADMIN       | ROLE_USER        | ROLE_USER        | ROLE_USER        |
| delete  | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN |

En el sistema existe un controlador llamado searchController, quiero que la exista un método `name` en el controlador searchController con la ruta `#[Route('/{name}/name', name: 'app_search_name_index')]`.

La acción será la siguiente: al ingresar a la ruta se mostrarán dos tablas: La primera tabla mostrará una lista de Patient que tienen una Attendance cuyo `checkInAt` es del día de hoy, el `checkOutAt` está vacío y cuyo `name` tiene el criterio solicitado en la ruta. La segunda tabla mostrará una lista Visitor cuyo `checkInAt` es del día de hoy, el `checkOutAt` está vacío y cuyo `name` tiene el criterio solicitado en la ruta.

Esta ruta usará el template `search/check_out.html.twig`. Este template debe ser modificado para que admita la variable optativa `name` de la ruta y como `title` tendrá la cadena `Search by Name`.

Toma en cuenta que este template usa las rutas `app_patient_check_out` y `app_visitor_check_out`, que deben funcionar y ahora redireccionar a `app_search_name_index`.

Ten cuidado al modificar este template, porque se usa en otros métodos, mismos que deben seguir funcionando.

Usa SearchRepository para escribir las consultas DQL necesarias. Si surge algún error, notifica inmediatamente, con una captura de pantalla, así podré darte instrucciones.

Ejemplo de criterio para la consulta DQL necesaria para la ruta `app_search_name_index` como `name`:

- Si entro en /fabian/name obtendré como resultados de la consulta a la base de datos los name: `Fabian`, `Joaquín Fabian Rivas`, `MIRIAM FABIAN`, `fabian Hernández` `fabían`, etc.
- Si entro en /foo+bar/name obtendré como resultados de la consulta a la base de datos los name:
`Foo Bar`, `foo bar`, `FOO BAR`, `zaz foo bar zoz`, etc.

Otras notas adicionales:

1. No elimines los métodos existentes en SearchController porque aún serán usados en el sistema.
2. Comenta temporalmente las líneas denyAccessUnlessGranted para que no se necesite un control de acceso al probar el código.

Muéstrame imágenes de cada template resultado.

***

Similar al método `name` creado, necesitaré un método llamado `nameAll`, muy similar al anterior, pues la ruta funciona igual `#[Route('/{name}/nameAll', name: 'app_search_nameAll_index')]`.

La ruta usará el template `search/name.html.twig`, al ingresar a la ruta se mostrarán dos tablas: La primera tabla mostrará una lista de Patient cuyo `name` tiene el criterio solicitado en la ruta. La segunda tabla mostrará una lista Visitor cuyo `name` tiene el criterio solicitado en la ruta.

La tabla de Patient tiene las siguientes columnas:

- id
- file
- name
- actions, que tendrá un botón que lleva a la ruta `app_patient_show` y otro que lleva a `app_patient_edit`

La tabla Visitor tiene las siguientes columnas:

- id
- name
- tag
- CheckInAt
- CheckOutAt Un botón que enlace a la ruta `app_visitor_check_out` si es que `CheckOutAt` no tiene valor, de otra manera, mostrará el valor de `CheckOutAt`
