# Batch Scheduleds

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

Actualmente existen ocho entidades consolidadas: Stakeholder, Patient, Hospitalized, Visitor, Appointment, Attendance, Area, Employee, cada una tiene sus templates CRUD creados. También hay una entidad User para control de usuarios. La jerarquía de permisos es la siguiente, de menos permisos a más permisos: ROLE_USER, ROLE_ADMIN, ROLE_SUPER_ADMIN

Hay un control de acceso a usuarios a nivel del controlador ilustrado en la siguiente tabla de permisos, en los métodos indicados en la primera columna.

|        | Patient/Hospitalized | Appointment      | Attendance       | Visitor/Stakeholder | User             | Area             | Employee         |
| index  | ROLE_USER            | ROLE_USER        | ROLE_USER        | ROLE_USER           | ROLE_ADMIN       | ROLE_USER        | ROLE_USER        |
| show   | ROLE_USER            | ROLE_USER        | ROLE_USER        | ROLE_USER           | ROLE_USER        | ROLE_ADMIN       | ROLE_ADMIN       |
| new    | ROLE_ADMIN           | ROLE_ADMIN       | ROLE_USER        | ROLE_USER           | ROLE_ADMIN       | ROLE_USER        | ROLE_USER        |
| edit   | ROLE_ADMIN           | ROLE_ADMIN       | ROLE_USER        | ROLE_USER           | ROLE_USER        | ROLE_ADMIN       | ROLE_ADMIN       |
| delete | ROLE_SUPER_ADMIN     | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN    | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN |

Acabo de incorporar un nuevo controlador llamado Scheduled. Tiene el CRUD básico ya elaborado, lo que necesito es agregar una nueva funcionalidad: importar valores a esa tabla en la base de datos desde un archivo CSV, aquí el ejemplo:

```CSV
area_id,label,name,institution,subject,begin_at,end_at
3,300234024,"Edgar Uriel Domínguez Espinoza",UNAM,2026-09-10,2026-09-10
33,116250291,"Karen Areli Nolasco Hernández",UREM,2026-09-10,2027-09-10
```

La funcionalidad, debe cumplir con las siguientes características:

1. Subir un archivo con la extensión permitida.
2. Colocar el archivo en una ubicación temporal y leerlo
3. Comprobar archivo:
   - ¿Existe la cabecera?
   - ¿Faltan columnas?
   - ¿Hay columnas desconocidas?
   - ¿Hay columnas duplicadas?
   - ¿El número de columnas es correcto?
   - ¿El encoding es correcto?
   - ¿El delimitador es correcto?
4. Validaciones:
   - El area_id existe en la tabla de la entidad Area.
   - El subject tiene uno de estos valores: 'Cultura', 'Documentación', 'Escuela', 'Estudiante', 'Expositor', 'Medio de comunicación', 'Proveedor', 'Trabajo'.
   - begin_at y end_at son fechas, end_at puede ser un valor igual o mayor a begin_at.
5. Detectar registros existentes:
   - El campo "label" debe ser único, por lo que si "label" ya existe en la base de datos, debe considerarse como un registro existente.
   - Ubicar filas que están duplicadas dentro del mismo archivo, aunque no estén en la base de datos.
6. Mostrar una vista previa con la siguiente información:
   - Nombre del archivo.
   - Número de filas totales.
   - Número de registros nuevos.
   - Número de registros existentes.
   - Número de filas duplicadas en el archivo.
   - Número de registros con errores.
   - Tabla de previsualización con las columnas del archivo original, más otras tres: fila, estado y detalle.
	 + Fila: muestra en que número de fila del archivo está el registro.
	 + Estado: estado del registro, si es nuevo, existente, duplicado o error.
	 + Detalle: Muestra que está mal en el registro, para que se pueda corregir posteriormente.
   - Un selector (checkbox o radio) con dos opciones sobre que hacer con los registros existentes: Omitir existentes, Actualizar existentes.
   - Botones de Cancelar la importación o Continuar con la importación.
7. Realizar la importación.
8. Mostrar resultado del proceso.
   - Estado: importación exitosa, importación fallida.
   - Número de registros efectivamente creados.
   - Número de registros efectivamente actualizados.
   - Número de registros omitidos.
   - Número de registros efectivamente erróneos.
   - Opción de descargar un nuevo archivo CSV que contenga los registros omitidos y erróneos únicamente.

Determina la viabilidad de usar el Bundle hugoseigle/symfony-import-export-bundle de Symfony para abordar este proceso y usar archivos CSV y XLSX.
