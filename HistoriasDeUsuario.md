# Historias de usuario

## Problema 1
Hay muchas áreas que están proporcionando listados para el ingreso de pacientes. Buscar en esas listas es ineficiente.
### Historia
Yo como _guarda de seguridad_ quiero **buscar la cita que tiene un paciente** para **permitirle el ingreso y dar instrucciones sobre su estancia en el hospital**.
### Requisitos de aceptación
- Que el guarda de seguridad pueda ver las citas que tiene un paciente en la fecha actual por medio de su número de expediente
- Que la lista de citas esté actualizada, muestre citas válidas, incluidas las agendadas vía telefónica

## Problema 2
Un paciente puede entrar por admisión o por consulta externa. La información sobre los pacientes debe estar disponible para todo el personal de seguridad que lo requiera.
### Historia
Yo como _guarda de seguridad_ quiero **tener acceso a la lista de pacientes con cita en el día presente en todos los módulos de entrada** para **identificar si un paciente debe ingresar al hospital**.
### Requisitos de aceptación
- Tener una sola lista que concentre todas las listas que se envían por área
- La lista debe tener información homogénea

## Problema 3
La fila de ingreso en vigilancia puede llegar a ser demasiado larga
### Historia
Yo como _guarda de seguridad_ quiero **escanear el código de barras del carnet** para **agilizar al máximo la atención**.
### Requisitos de aceptación
- Al escanear al código debe mostrar la información relacionada con el paciente

## Problema 4
Se han abierto o cambiado muchas ubicaciones dentro del hospital, lo cual genera retrasos
### Historia
Yo como _camillero_ quiero **saber el destino preciso del paciente** para **poder llevarlo a la ubicación correcta en el menor tiempo posible**
### Requisitos de aceptación
- Tener una lista actualizada de servicios y clínicas
- Incluir horarios de las clínicas
- La lista debe incluir las actividades que realiza cada servicio

## Problema 5
Se solicita una silla para un paciente que no tiene problemas de movilidad
## Historia
Yo como _solicitante al servicio de camillería_ quiero **tener una serie de criteros** para **determinar si un paciente requiere el servicio o no**
### Requisitos de aceptación
- Criterio o protocolo sencillo y claro


# Preguntas

## Pregunta 1
¿Cómo manejar pacientes que deben reprogramar/reagendar citas canceladas/modificadas
### Respuesta
Será un proceso de decisión fuera del sistema
## Pregunta 2
¿Se requiere alguna restricción de tiempo para el registro de entrada y/o salida?
### Respuesta
No
