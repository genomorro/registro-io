# Fix Command Update

Este es un proyecto de Synfony 7.4, requiere instalar PHP 8.4 y MariaDB 11 o SQLite3 como base de datos. Los datos de conexión a la base de datos puedes colocarlos en el archivo `.env` agregando una línea como: 
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

|         | Patient/Hospitalized  | Appointment      | Attendance       | Visitor          | User             |
| index   | ROLE_USER             | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_ADMIN       |
| show    | ROLE_USER             | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_USER        |
| new     | ROLE_ADMIN            | ROLE_ADMIN       | ROLE_USER        | ROLE_USER        |                  |
| edit    | ROLE_ADMIN            | ROLE_ADMIN       | ROLE_USER        | ROLE_USER        | ROLE_USER        |
| delete  | ROLE_SUPER_ADMIN      | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN |

Existe el comando `app:import-data` que importa registros de una base de datos externa al sistema. Cuando la base de datos del sistema es SQLite3, este comando bloquea la base de datos. Impidiendo que sea usada.

Esto causa un error 500 con la siguiente descripción: An exception occurred while executing a query: SQLSTATE[HY000]: General error: 5 database is locked

Quiero que modifiques los comandos `app:import-data:patient`, `app:import-data:appointment`, `app:import-data:hospitalized` creando la opción `--update` o `-u` para que lean los registros de la base de datos y si hay cambios con respecto a la base de datos origen realicen los cambios pertinentes, ya sea actualizar un registro, borrar un registro que ya no está o crear un registro nuevo. De tal forma que no haya necesidad de borrar toda la información de las tablas como ahora.

Notas a considerar:

1. Quiero conservar el comportamiento actual de los comandos, por lo que no debes borrar está lógica, solo agregar la nueva.
2. Estas nuevas funciones deben poder usarse tanto en SQLite3 como en MySQL

*** 
Me encuentro con los siguientes problemas:

1. Cuando ejecuto `php  bin/console app:import-data`, no se ejecuta el comando, por alguna razón no logra conectarse a la base de datos, aunque si ejecuto los comandos por separado si lo hace. El error es el siguiente:
```
```

2. Cuando ejecuto `php  bin/console app:import-data:patient` obtengo un error que parece aislado, pero me gustaría que analizaras:
```
[ERROR] An error occurred during data update: While adding an entity of class App\Entity\Patient with an ID hash of    
         "727317" to the identity map,                                                                                  
         another object of class App\Entity\Patient was already present for the same ID. This exception                 
         is a safeguard against an internal inconsistency - IDs should uniquely map to                                  
         entity object instances. This problem may occur if:                                                            
                                                                                                                        
         - you use application-provided IDs and reuse ID values;                                                        
         - database-provided IDs are reassigned after truncating the database without                                   
         clearing the EntityManager;                                                                                    
         - you might have been using EntityManager#getReference() to create a reference                                 
         for a nonexistent ID that was subsequently (by the RDBMS) assigned to another                                  
         entity.                                                                                                        
                                                                                                                        
         Otherwise, it might be an ORM-internal inconsistency, please report it.           
```
