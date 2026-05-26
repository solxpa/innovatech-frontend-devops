wEvaluación Parcial N°2: Encargo con Presentación 

Instrucciones y pauta de evaluación | Estudiante **Institución:** Duoc UC  | Subdirección de Diseño Curricular e Instruccional (2025) 

### Resumen de la Asignatura

| Sigla | Nombre Asignatura | Tiempo Asignado | % Ponderación |
| --- | --- | --- | --- |
| **ISY1101** | Introducción a Herramientas devops | 6 h | 30%

 |

---

1. Instrucciones Generales 

Descripción 

La evaluación consiste en una práctica de contenedorización y despliegue automatizado en AWS. Cada dupla deberá trabajar sobre los repositorios entregados (frontend y backend en microservicios) para dockerizar la solución, publicar las imágenes en un registro de contenedores y automatizar el despliegue mediante GitHub Actions.

El encargo incluye la creación de `Dockerfile` (multi-stage, mínimo privilegio) para cada componente, la configuración de un archivo `docker-compose.yml` para levantar el stack de servicios, y la ejecución de los contenedores en una instancia EC2. Adicionalmente, la dupla deberá implementar un pipeline CI/CD en GitHub Actions que, al realizar un *push* sobre la rama `deploy` de cada repositorio, construya las imágenes, las publique en el registro definido y despliegue la versión actualizada en la instancia EC2.

La evaluación se completa con una presentación y defensa técnica, en la cual los estudiantes deberán justificar sus decisiones, explicar el flujo de trabajo implementado y responder preguntas relacionadas con contenedorización, despliegue en AWS y automatización con GitHub Actions.

### Tiempos y Fechas

* 
**Tiempo asignado:** 1 semana para la elaboración del encargo y la presentación.


* 
**Desarrollo:** Las/los estudiantes inician el trabajo en el Taller de Proyectos (Taite 7), pero deben finalizarlo junto a la presentación en su tiempo de trabajo personal.



### Distribución de la Evaluación

| Evaluación Parcial N° 2 (30%) | Tipo de situación evaluativa | Distribución de porcentajes en el EP2 | Modalidad |
| --- | --- | --- | --- |
|  | Encargo | 20% | Parejas

 |
|  | Presentación | 80% | Individual

 |
| **Total** |  | **100%** |  |

> 
> **Nota:** El Encargo corresponde a la entrega de los repositorios del front y backend.
> 
> 

---

Contexto del Caso: Innovatech Chile 

La empresa Innovatech Chile ha decidido continuar a la etapa 2 del proyecto. El equipo deberá desplegar la aplicación en la infraestructura construida en la Evaluación Parcial N°1, cumpliendo con los siguientes requerimientos técnicos:

1. Contenedorización de Frontend y Backend Cada repositorio debe incluir toda la estructura necesaria para ejecutar los proyectos dentro de contenedores, lo que implica:

* Un `Dockerfile` correctamente construido (idealmente con *multi-stage build*).


* Un archivo `docker-compose.yml` que permita levantar los servicios asociados.


* Configuración de variables de entorno, puertos, dependencias y volúmenes según corresponda.


* Los proyectos deben ser capaces de ejecutarse de forma independiente y conjunta.



2. Persistencia de Datos 

* Aplicar persistencia utilizando volúmenes Docker definidos en los archivos docker-compose.


* Asegurar que la información crítica del Backend o base de datos no se pierda al reiniciar contenedores.


* Justificar la elección de los volúmenes (*bind mount* vs. *named volume*).



3. Pipeline de Integración y Despliegue Continuo (CI/CD) Configurar los repositorios para ejecutar los pipelines mediante un archivo de *workflow* en GitHub Actions que:

* Construya la imagen Docker.


* Publique la imagen en ECR o Docker Hub.


* Despliegue automáticamente en la instancia EC2.


* Maneje adecuadamente *secrets* (credenciales, tokens, variables).


* Utilice *triggers* basados en la rama `deploy`.


* Tenga pasos claros y documentados.



4. Funcionamiento en Instancias EC2 

* **Instancia Frontend:** Debe ejecutar el contenedor desde la imagen, iniciar sin errores y ser accesible vía navegador (dominio/IP). Se debe comprobar lectura de variables y puertos expuestos.


* 
**Instancia Backend:** Debe conectarse a la base de datos, responder peticiones del Frontend y mantener persistencia de volúmenes.



5. Visualización e Integración Front-Back 

* Visualización web sin errores.


* Comunicación entre Front y el Backend en la subred privada.


* Consumo correcto de *endpoints*.


* Respeto de políticas de seguridad en los Security Groups.



---

Ítem I: Consideraciones para el Encargo y Presentación 

La dupla deberá demostrar y justificar los siguientes puntos (Indicadores de Evaluación - IE):

* IE1. Contenedorización: Estructura en repositorios, uso de `Dockerfile` (multi-stage, usuario no root, limpieza), `docker-compose.yml`, y separación clara Front-Back en AWS EC2.


* IE2. Persistencia: Aplicación de volúmenes en BD/Backend, tipo elegido y garantía de continuidad operativa tras reinicios.


* IE3. Pipeline CI/CD: Flujo de Actions documentado (Build -> Push a ECR/Docker Hub -> Deploy a EC2), *triggers* en la rama `deploy` y uso de GitHub Secrets.


* IE4. Funcionamiento en EC2: Despliegue validado desde repositorios (ej. *[https://github.com/XXX/frontend](https://github.com/XXX/frontend)*) a instancias con accesos y puertos correctos.


* IE6. Justificación de Diseño: Argumentar decisiones de contenedores, redes y requerimientos de seguridad/rendimiento en EC2.


* IE7. Justificación del Pipeline: Explicar automatización, gestión de secretos y por qué es crítico para la empresa.


* IE8. Principios DevOps: Explicar cómo la gestión de entornos, control de versiones y automatización favorecen la escalabilidad.


* IE9. Demostración funcional (En Vivo): Probar accesos a EC2, persistencia, consumo de endpoints y flujo CI/CD al hacer *push*.



Aspectos Formales y Medios de Entrega 

* **Formato:** Entregar repositorios documentados con `README.md` que explique su uso. Los *commits* deben ser explicativos (entender cambios, *fix* o *update*).


* 
**Entrega:** Mediante plataforma AVA.


* 
**Herramientas:** Cuenta AWS Academy, VS Code, Docker Desktop, AWS CLI, Git, PC en lab TAITE 7.



---

2. Pauta de Evaluación y Rúbrica 

### Niveles de Logro

| Categoría | % Logro | Descripción |
| --- | --- | --- |
| **Muy buen desempeño** | 100% | Desempeño destacado, logro de todos los aspectos. 

 |
| **Buen desempeño** | 80% | Alto desempeño, pequeñas omisiones o dificultades. 

 |
| **Desempeño aceptable** | 60% | Logro de elementos básicos, pero con errores u omisiones. 

 |
| **Desempeño incipiente** | 30% | Errores importantes, no se logran elementos básicos. 

 |
| **Desempeño no logrado** | 0% | Ausencia o incorrecto desempeño. 

 |

### Tabla de Rúbrica de Indicadores

| Indicador de Evaluación | 100% (Muy Bueno) | 80% (Bueno) | 60% (Aceptable) | 30% (Incipiente) | 0% (No logrado) | Ponderación |
| --- | --- | --- | --- | --- | --- | --- |
| IE1. Contenedorización Front/Back 

 | `Dockerfile` multi-stage óptimo, sin root, capas limpias, seguro. | Funcional con detalles menores. | Incompleto, sin multi-stage o con fallas. | Errores graves. | No presenta `Dockerfile`. | **20%** |
| IE2. Configuración docker-compose 

 | Completo (servicios, redes, variables, dependencias). | Funcional con leves omisiones. | Errores moderados en puertos/dependencias. | Incompleto o falla al iniciar. | No presenta compose. | **10%** |
| IE3. Persistencia de datos 

 | Implementada y justificada correctamente. | Funcional con detalles menores. | Parcial o con errores. | Inconsistente. | No implementa persistencia. | **10%** |
| IE4. Pipeline CI/CD 

 | Completamente funcional, automatizado y seguro. | Funcional con omisiones menores. | Parcial (ej. build OK, deploy fallido). | Inestable o errores graves. | No presenta pipeline. | **20%** |
| IE5. Contenedor Front en EC2 

 | Accesible por IP/dominio, sin errores. | Funciona con detalles menores. | Parcial con fallas visibles. | Errores críticos. | No funciona. | **15%** |
| IE6. Contenedor Back en EC2 

 | Conectado a BD, estable y responde. | Funciona con detalles menores. | Funcional parcialmente. | Fallas graves. | No funciona. | **15%** |
| IE7. Integración Front -> Back 

 | Estable, endpoints correctos, SG aplicados. | Leves errores de comunicación. | Comunicación parcial. | Fallas graves. | Sin comunicación. | **5%** |
| IE8. Documentación repositorio 

 | Completa, profesional, clara, técnica. | Correcta con detalles. | Básica. | Incompleta. | No documenta. | **5%** |