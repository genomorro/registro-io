# registro-io

Sistema de registro de entrada y salida para los pacientes del INER y sus familiares, ya sean acompañantes o visitas.

## Git
Clonar el proyecto de manera habitual, luego cargar el submódulo:

	git submodule init
	git submodule update
	
Si se trabaja desde Gitlab, funcionará el espejo hacia Github. Pero si se decide trabajar desde Github, es necesario agregar Gitlab como origen y posteriormente sincronizar de forma manual:

	git remote add origin2 https://gitlab.com/genomorro/registro-io.git
	git branch -M main
	git remote -v
	git push -uf origin2 main

No olvidar que Github maneja como rama principal _master_ y Gitlab es _main_.

## Requisitos
Al consultar se debe mostrar todo aquello agendado para el día actual únicamente.

Se debe registrar cuando un familiar pasa al instituto, por lo que se debe ligar con el paciente, y cada paciente debe tener dos posibles familiares asociados a la vez.

Cada familiar debe tener un número de gafete, será posible buscar al familiar por número de gafete, cada familiar debe tener:

- Nombre del familiar
- Número de gafete
- Destino
- Hora de entrada
- Hora de salida

## Datos requeridos del ECE
1. Número de expediente
2. Nombre del paciente
3. Fecha y hora de la cita
4. Especialidad de la cita
5. Si la cita es por consulta, estudios o procedimiento
6. Lugar de realización

Con esto se permitirá el ingreso al instituto.

## Development
El sistema esta elaborado en Symfony 6.4 LTS:

    Requires: PHP 8.1.0 or higher
    Latest patch version: 6.4.25
    Released on: November 2023
    End of bug fixes: November 2026
    End of security fixes: November 2027

El código fuente está disponible en Gitlab.
	
	https://gitlab.com/genomorro/registro-io.git
	
Symfony se instaló con el siguiente comando:

	symfony new public_html --version=lts --webapp
	
Para iniciar el web server de desarrollo:

	symfony server:start
	
Estará disponible por medio del [navegador web](http://localhost:8000)

Se crearon las entidades con 

	php bin/console make:entity
	
Para incorporar cambios en la base de datos:

	php bin/console make:migration  --formatted
	php bin/console doctrine:migrations:migrate

Luego el CRUD, el cual si crea archivos adicionales:

	php bin/console make:crud

	The class name of the entity to create CRUD (e.g. TinyGnome):
	> Paciente
	
	Choose a name for your controller class (e.g. PacienteController) [PacienteController]:
	> 
	
	Do you want to generate PHPUnit tests? [Experimental] (yes/no) [no]:
	> 
		
	created: src/Controller/PacienteController.php
	created: src/Form/PacienteType.php
	created: templates/paciente/_delete_form.html.twig
	created: templates/paciente/_form.html.twig
	created: templates/paciente/edit.html.twig
	created: templates/paciente/index.html.twig
	created: templates/paciente/new.html.twig
	created: templates/paciente/show.html.twig
	
	
	Success! 
	
	
	Next: Check your new CRUD by going to /paciente/

***

# Instalación
<!--  TODO:  -->
Al descargar los repositorios, lo primero es entrar en _public_html_ y ejecutar:

	composer install

## Soporte

## Roadmap
Este es un proyecto de Synfony 6.4, requiere instalar PHP 8.4 y MariaDB. Los datos de conexión a la base de datos puedes colocarlos en el archivo .env agregando una línea como:

	DATABASE_URL="mysql://db_user:db_password@127.0.0.1:3306/db_name?serverVersion=10.5.8-MariaDB"

Ejemplo:

	DATABASE_URL="mysql://registro-io:registro-io.passwd@127.0.0.1:3306/registro-io?serverVersion=11.8.3-MariaDB-0+deb13u1+from+Debian"

Todas las consultas a la base de datos deben ser creadas con DQL, pues el proyecto usa Doctrine, y deben ser declaradas en los archivos que se encuentran el el directorio src/Repository/

Se puede iniciar un servidor de prueba con la instrucción:

	symfony server:start

Luego, se accede por medio de la dirección http://localhost:8000

Los controladores de cada entidad se encuentran en src/Controller/, ellos envían la información con la cual se forman los templates. Los formularios se crean según los archivos localizados en src/Form/ 

Actualmente existen dos entidades, Patient y Date, cada una tiene sus templates CRUD creados.

Modifica esos templates, para que en templates/patient/index.html.twig aparezcan solo los registros que tengan al menos una Date con la propiedad "time" para el día actual, es decir, para hoy.

En templates/patient/show.html.twig debe aparecer la información del Patient solicitado, luego una lista de Date que tenga para el día de hoy, finalmente, debe aparecer una lista con las Date que no sean del día de hoy.

## Contribuciones
Si planeas contribuir a este proyecto, por favor usa el repositorio `registro-io` para cualquier tipo de documentación, usa `registro-io-code` para contribución de código fuente. Cualquier error o bug sobre el código, debe ser reportado en `registro-io-code`.

## Licencia
This repo is part of Actividades escolares UNIR

Copyright (C) 2022, Edgar Uriel Domínguez Espinoza

Registro de I/O INER is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

Registro de I/O INER is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Registro de I/O INER; if not, see http://www.gnu.org/licenses/ or write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
