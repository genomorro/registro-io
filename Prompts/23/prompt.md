Search by tag

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

En el sistema existe un controlador llamado searchController, quiero que la exista un método `checkOut` en el controlador searchController con la ruta `#[Route('/{tag}/checkOut', name: 'app_search_check_index')]`.

La acción será la siguiente: al ingresar a la ruta se mostrarán dos tablas: La primera tabla mostrará una lista de Patient que tienen una Attendance cuyo `checkInAt` es del día de hoy, el `checkOutAt` está vacío y cuyo `tag` tiene el criterio solicitado en la ruta. La segunda tabla mostrará una lista Visitor cuyo `checkInAt` es del día de hoy, el `checkOutAt` está vacío y cuyo `tag` tiene el criterio solicitado en la ruta.

La tabla de Patient tiene las siguientes columnas:

- id
- file
- name
- valor del `tag` registrado en Attendance
- `checkInAt` registrado en Attendance
- un botón que enlace a la ruta `app_patient_check_out_tag`

La tabla Visitor tiene las siguientes columnas:

- id
- name
- tag
- CheckInAt
- Un botón que enlace a la ruta `app_visitor_check_out_tag`

La ruta `app_patient_check_out_tag` es igual que `app_patient_check_out`, solo que la instrucción redirectToRoute() lleva a la misma página de `app_search_check_index` que se está viendo.

La ruta `app_visitor_check_out_tag` es igual que `app_visitor_check_out`, solo que la instrucción redirectToRoute() lleva a la misma página de `app_search_check_index` que se está viendo.

Si lo necesitas, puedes crear un repositorio llamado SearchRepository con las consultas DQL necesarias.

Si surge algún error, notifica inmediatamente, con una captura de pantalla, así podré darte instrucciones.

Los dos botones solicitados, tienen la forma:
```twig
<form method="post" action="{{ path('app_patient_check_out_tag', {'id': patient.id}) }}" onsubmit="return confirm('{% trans %}Are you sure you want to check out?{% endtrans %}');">
    <button type="submit" class="btn btn-sm btn-danger">{% trans %}Check out{% endtrans %}</button>
</form>


<form method="post" action="{{ path('app_visitor_check_out_tag', {'id': visitor.id}) }}" onsubmit="return confirm('{% trans %}Are you sure you want to check out?{% endtrans %}');">
    <button class="btn btn-sm btn-danger">{% trans %}Check out{% endtrans %}</button>
</form>
```

Ejemplo de criterio para la consulta DQL necesaria para la ruta `app_search_check_index` como `tag`:

- Si busco entro en /555/checkOut obtendré como resultados de la consulta a la base de datos los tag `555`, `5555`, `7555`, `5552`, etc.

Otras notas adicionales:

1. No elimines los métodos existentes en SearchController porque aún serán usados en el sistema.
2. Comenta temporalmente las líneas denyAccessUnlessGranted para que no se necesite un control de acceso al probar el código.

Muéstrame imágenes de cada uno de los templates modificados y modificados.
