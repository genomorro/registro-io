# UUID en URI

Este es un proyecto de Synfony 7.4, requiere instalar PHP 8.4 y MariaDB 11 o SQLite3 como base de datos. Se usan dos comandos php principalmente, composer y symfony. Los datos de conexión a la base de datos puedes colocarlos en el archivo `.env` agregando una línea como:
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
```bash
symfony server:start
```
Para tener el comando symfony en Docker se puede agregar al Dockerfile:
```
COPY --link
	--from=ghcr.io/symfony-cli/symfony-cli:latest
	/usr/local/bin/symfony /usr/local/bin/symfony
```
Luego, se accede por medio de la dirección http://localhost:8000

Los controladores de cada entidad se encuentran en src/Controller/, ellos envían la información con la cual se forman los templates. Los formularios se crean según los archivos localizados en src/Form/. Los commando se encuentran en src/Command.

Actualmente existen seis entidades: Stakeholder, Patient, Hospitalized, Visitor, Appointment y Attendance, cada una tiene sus templates CRUD creados. También hay una entidad User para control de usuarios. La jerarquía de permisos es la siguiente (no incluye aun Stakeholder), de menos permisos a más permisos: ROLE_USER, ROLE_ADMIN, ROLE_SUPER_ADMIN

Hay un control de acceso a usuarios a nivel del controlador ilustrado en la siguiente tabla de permisos, en los métodos indicados en la primera columna.

|        | Patient/Hospitalized | Appointment      | Attendance       | Visitor          | User             |
| index  | ROLE_USER            | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_ADMIN       |
| show   | ROLE_USER            | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_USER        |
| new    | ROLE_ADMIN           | ROLE_ADMIN       | ROLE_USER        | ROLE_USER        | ROLE_ADMIN       |
| edit   | ROLE_ADMIN           | ROLE_ADMIN       | ROLE_USER        | ROLE_USER        | ROLE_USER        |
| delete | ROLE_SUPER_ADMIN     | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN |

Actualmente, tengo rutas del tipo "/patient/19" donde el número es el ID de la base de datos. Quiero que en las rutas no se muestre esa información, ya sea que se omita o sea sustituía.

¿Que puedes implementar para este requerimiento?
***

iFrame

Necesito que la URI del proyecto nunca cambie en el navegador y solo se muestre el dominio principal.

Es decir, que siempre se muestre accesos.iner.gob.mx en la barra de navegación del navegador web, aunque la ruta del sistema sea, por ejemplo, accesos.iner.gob.mx/patient/19

Hay una forma en la que symfony maneje ese comportamiento.

***

Puedes implementar el uso de un ID público para las URI.

Quero que la ruta en el navegador, en lugar de que sea "/patient/19" cambie a algo similar de "/patient/550e8400-e29b-41d4-a716-446655440000".

No quiero cambiar el ID interno de la base de datos ni modificar la DB porque importo datos de otra DB comúnmente, pero necesito el uso de UUID únicos en la URI.

¿Podrías implementar algún tipo de hash para el id de cada entidad, el cual transforme dicho número sin tener que usar un segundo id "público"? O dame alguna otra alternativa que esté disponible en Symfony.


***

#[ORM\Column(length: 64, unique: true)]
private string $publicId;






use Symfony\Component\Uid\Uuid;

$this->publicId = Uuid::v4()->toRfc4122();






#[Route('/patient/{publicId}')]
public function show(string $publicId, PatientRepository $repo)
{
    $patient = $repo->findOneBy(['publicId' => $publicId]);
}
