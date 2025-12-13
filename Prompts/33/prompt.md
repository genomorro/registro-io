# Servicio Patient

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

Los controladores de cada entidad se encuentran en src/Controller/, ellos envían la información con la cual se forman los templates. Los formularios se crean según los archivos localizados en src/Form/

Actualmente existen cinco entidades, Patient, Hospitalized, Visitor, Appointment y Attendance, cada una tiene sus templates CRUD creados. También hay una entidad User para control de usuarios. La jerarquía de permisos es la siguiente, de menos permisos a más permisos: ROLE_USER, ROLE_ADMIN, ROLE_SUPER_ADMIN

Hay un control de acceso a usuarios a nivel del controlador ilustrado en la siguiente tabla de permisos, en los métodos indicados en la primera columna.

|         | Patient/Hospitalized  | Appointment      | Attendance       | Visitor          | User             |
| index   | ROLE_USER             | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_ADMIN       |
| show    | ROLE_USER             | ROLE_USER        | ROLE_USER        | ROLE_USER        | ROLE_USER        |
| new     | ROLE_ADMIN            | ROLE_ADMIN       | ROLE_USER        | ROLE_USER        |                  |
| edit    | ROLE_ADMIN            | ROLE_ADMIN       | ROLE_USER        | ROLE_USER        | ROLE_USER        |
| delete  | ROLE_SUPER_ADMIN      | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN | ROLE_SUPER_ADMIN |

Actualmente, uso un script de Python para actualizar la base de datos, quiero crear un servicio PHP dentro del proyecto que sustituya el script de Python. El servicio PHP debe ser invocado de la siguiente manera:
```bash
php bin/console app:import-data
```
Ese servicio en realidad va a ejecutar tres comandos: `php bin:console app:import-data:patient`, `php bin:console app:import-data:appointment`, `php bin:console app:import-data:hospitalized`. En esta ocasión solo vas a crear `php bin:console app:import-data:patient`, que corresponde al código Python siguiente:
```python
#!/usr/bin/python3
from datetime import datetime
import csv
import os
import pandas as pd
import sqlalchemy as db

dir = os.path.abspath(os.getcwd())
environtment = "dev"

engine = db.create_engine("mysql://pbaconnectmsql:Tduc$aupydl$5t@192.168.27.30/r3sp1ra770ri4x8025")
conn = engine.connect()

df_p = pd.read_sql('SELECT * FROM pacientes', conn)

patient_columns = ["idPac", "numExpediente"]
patient = df_p.loc[3:, patient_columns].copy()
patient.columns = ["id", "file"]

patient["name"] = df_p.loc[3:, "nomPaciente"].fillna('') + " " + df_p.loc[3:, "primerApellido"].fillna('') + " " + df_p.loc[3:, "segundoApellido"].fillna('')

comma = ','
patient['name'] = patient['name'].replace({comma:''}, regex=True)

df_p["tipoDificultad"].unique().tolist()

def disability_to_dummy(x):
  """
  Read a column with multiple options of disability.
  
  Parameters
  ----------
  x: string
     a disability or not.
     
  Returns
  -------
  If there is a disability return 1, else return 0.
  """
  if (x == "NINGUNA" or
      x == "SE IGNORA"):
      return 0
  else:
      return 1

patient["disability"] = df_p.loc[3:, "tipoDificultad"].map(disability_to_dummy)

database = os.path.dirname(dir) + "/public_html/var/data_" + environtment + ".db"
sqlite_engine = db.create_engine('sqlite:///' + database)
patient.to_sql('patient', sqlite_engine, if_exists='replace', index=False)
```
Es importante la consistencia de los valores de la base de datos, incluyendo que el valor de `idPac` de la tabla origen debe ser el `id` de la tabla destino. Además procura que el valor de `patient` en la tabla `sqlite_sequence` de la base de datos destino sea igual al valor máximo de `id` de la tabla `patient`.

***

Información adicional:

1. La base de datos origen tiene una tabla llamada `pacientes` con las siguientes columnas: ['idPac', 'numExpediente', 'nomPaciente', 'primerApellido', 'segundoApellido', 'sexo', 'fechaNacimiento', 'curp', 'descConvenio', 'nivelSE', 'derHab', 'excentoPago', 'tipoDificultad']
2. La base de datos destino tiene una tabla llamada `patient`, que corresponde a la entidad Patient.php
3. Igualando las tablas origen y destino: 'idPac' = 'id', 'numExpediente'='file'. La columna destino 'name' es la concatenación de 'nomPaciente', 'primerApellido', 'segundoApellido'. Mientras que 'disability'='tipoDificultad', aunque antes, hay que pasar los valores a booleanos, donde 0 es "NINGUNA" y "Se IGNORA", cualquier otro valor será 1.
