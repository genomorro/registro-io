# Stakeholder Signature Pad

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

En la entidad Stakeholder existe la propiedad 'sign' que debe guardar la ruta de una imagen de una firma.

Esta propiedad 'sign' se registrará solamente en `app_stakeholder_new`. Insertas un <canvas> donde el usuario puede dibujar con mouse/touch, debes incluir un botón que limpie el <canvas>.
Puedes colocar el elemento arriba del área de video, inicia con algo así y modificalo según sea requerido:

```	
	<div class="col-md-6 d-flex align-items-center justify-content-center flex-column">
	    <canvas id="sign" width="480" height="200" class="border mt-3"></canvas>
	    <div class="my-2">
		<button type="button" class="btn btn-xs btn-danger">{% trans %}Clear Signature{% endtrans %}</button>
	    </div>

	    <video data-webrtc-target="video" width="480" height="360" class="border" poster="{{ asset('images/iner-logo.png') }}" autoplay></video>
	    <div class="my-2">
		<select data-webrtc-target="cameraSelect" data-action="change->webrtc#switchCamera" class="form-select form-select-sm d-none d-inline-block w-auto"></select>
		<button type="button" data-webrtc-target="flipButton" data-action="click->webrtc#flipCamera" class="btn btn-sm btn-secondary d-none">{% trans %}Flip Camera{% endtrans %}</button>
	    </div>
	    <canvas data-webrtc-target="canvas" class="d-none"></canvas>
	</div>
```

Tengo el siguiente parche para un archivo:
```
diff --git a/templates/stakeholder/new.html.twig b/templates/stakeholder/new.html.twig
index bf14c7f..abd9fb2 100644
--- a/templates/stakeholder/new.html.twig
+++ b/templates/stakeholder/new.html.twig
@@ -89,6 +89,11 @@
            {{ form_end(form) }}
        </div>
        <div class="col-md-6 d-flex align-items-center justify-content-center flex-column">
+           <canvas id="sign" width="480" height="200" style="background-color: #eaeaea;" class="border mt-3"></canvas>
+           <div class="my-2">
+               <button id="clear" type="button" class="btn btn-xs btn-danger">{% trans %}Clear Signature{% endtrans %}</button>
+           </div>
+
            <video data-webrtc-target="video" width="480" height="360" class="border" poster="{{ asset('images/iner-logo.png') }}" autoplay></video>
            <div class="my-2">
                <select data-webrtc-target="cameraSelect" data-action="change->webrtc#switchCamera" class="form-select form-select-sm d-none d-inline-block w-auto"></select>
@@ -98,3 +103,43 @@
        </div>
     </div>
 {% endblock %}
+
+{% block custom_javascripts %}
+    <script>
+     const canvas = document.getElementById("sign");
+     const ctx = canvas.getContext("2d");
+     let painting = false;
+
+     function startPosition(e) {
+         painting = true;
+         draw(e);
+     }
+
+     function finishedPosition() {
+         painting = false;
+         ctx.beginPath();
+     }
+
+     function draw(e) {
+         if (!painting) return;
+
+         ctx.lineWidth = 1;
+         ctx.lineCap = "round";
+         ctx.strokeStyle = "blue";
+
+         let rect = canvas.getBoundingClientRect();
+         ctx.lineTo(e.clientX - rect.left, e.clientY - rect.top);
+         ctx.stroke();
+         ctx.beginPath();
+         ctx.moveTo(e.clientX - rect.left, e.clientY - rect.top);
+     }
+
+     canvas.addEventListener("mousedown", startPosition);
+     canvas.addEventListener("mouseup", finishedPosition);
+     canvas.addEventListener("mousemove", draw);
+
+     document.getElementById("clear").addEventListener("click", () => {
+         ctx.clearRect(0, 0, canvas.width, canvas.height);
+     });
+    </script>
+{% endblock %}
```
Es una funcionalidad que crea un espacio de dibujo, el cual servirá para firmar. En estos momentos, este parche solo crea el área de firma y permite dibujar en ella. Quiero que apliques este parche, pero transformes el JavaScript en un controlador Stimulus llamado 'signature_controller.js'

No implementes aun ninguna otra funcionalidad, no necesito que guarde la imagen aun, solamente, que el controlador Stimulus logre dibujar en el <canvas>. Esto porque tengo problemas al hacer que funcione el controlador Stimulus, porque deja de dibujar.

***

Esta imagen se guardará en la ruta 'public/uploads/stakeholder/' con el nombre "id-fecha-.svg" donde id y fecha tienen el mismo valor de la imagen que captura la propiedad evidence de WebRTC.

En la base de datos se almacena la ruta a la imagen guardada. Cuando se guarda el registro del formulario, automáticamente se guarda la imagen de 'sign', muy similar a como sucede con 'evidence' en este momento.

Para el funcionamiento de la firma, puedes usar Signature Pad [1], instala este paquete con AssetMapper:

```
php bin/console importmap:require signature_pad
```

Después, crea un controlador Stimulus que interactúe con él área de firma y que envíe la imagen a StakeholderContoller, para que sea almacenada.

[1] https://github.com/szimek/signature_pad


Si puedes implementarlo, muéstrame una imagen del template modificado.

***

En la entidad Stakeholder existe la propiedad 'sign' que debe guardar la ruta de una imagen de una firma.

Esta propiedad 'sign' se registrará solamente en `app_stakeholder_new`. Insertas un <canvas> donde el usuario puede dibujar con mouse/touch, debes incluir un botón que limpie el <canvas>.

Crea un controlador Stimulus de JavaScript para capturar el dibujo. En la esquina inferior izquierda la imagen debe tener la fecha y hora del CheckInAt y en la esquina superior derecha el logo del INER, igual a como lo hace el controlador de Stimulus de WebRTC.

Está imagen se guardará en la ruta 'public/uploads/stakeholder/' con el nombre "id-fecha-.sign.png" donde id y fecha tienen el mismo valor de la imagen que captura la propiedad evidence de WebRTC.

En la base de datos se almacena la ruta a la imagen guardada. Cuando se guarda el registro del formulario, automáticamente se guarda la imagen de 'sign', muy similar a como sucede con 'evidence' en este momento.

Si puedes implementarlo, muéstrame una imagen del template modificado.


