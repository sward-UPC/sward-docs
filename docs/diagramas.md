# Diagramas de SWARD

Esta sección reúne los diagramas del proyecto SWARD usados en la tesis y el *short paper*: el
modelo **C4** de la arquitectura, los **diagramas de clases UML** por microservicio (arquitectura
hexagonal) y las figuras ya renderizadas de **integración con Moodle** y del **flujo pyKT**.

| Archivo | Qué representa | Formato |
|---------|----------------|---------|
| [`SWARD_C4_componentes_shortpaper.dsl`](diagramas/SWARD_C4_componentes_shortpaper.dsl) | **C4 reducido** (vista de contenedores condensada para el *short paper*): usuarios, los 6 microservicios, las lambdas de ingesta + event-driven, y los 3 flujos esenciales. | Structurizr DSL |
| [`SWARD_C4_completo.dsl`](diagramas/SWARD_C4_completo.dsl) | **C4 completo** (contexto + contenedores detallados): la versión extensa de la arquitectura, con todos los elementos y relaciones. | Structurizr DSL |
| [`plantuml/`](#diagramas-de-clases-uml-plantuml-arquitectura-hexagonal) | **Diagramas de clases (UML) por microservicio**, organizados según la **arquitectura hexagonal** (domain / application / ports / infrastructure): uno por cada uno de los 6 microservicios + el procesamiento asíncrono (Lambda/EventBridge/SQS) + una vista general del patrón hexagonal. | PlantUML (`.puml`) |
| [`diagrama_moodle.svg`](diagramas/diagrama_moodle.svg) | **Integración con Moodle** (flujo de ingesta): `EventBridge schedule → lambda moodle-sync → ms-integracion-lms → Moodle REST → PostgreSQL → EventBridge → SAKT`. | SVG / PNG |
| [`diagrama_pykt.svg`](diagramas/diagrama_pykt.svg) | **Flujo de la librería pyKT**: dataset crudo → preprocesamiento → split → modelo KT (DKT/SAKT) → entrenamiento → evaluación. | SVG / PNG |
| [DKT y pyKT](diagramas-dkt.md) | **Pseudocódigo del DKT** (Deep Knowledge Tracing) + versiones LaTeX/TikZ y Mermaid del flujo pyKT, listas para Overleaf y mermaid.live. | Markdown |

---

## El diagrama C4 (Structurizr)

`SWARD_C4_componentes_shortpaper.dsl` está escrito en **Structurizr DSL** (modelo C4, vista de
contenedores). Es la figura de referencia de la arquitectura: muestra los dos tipos de usuario
(estudiante, docente), todos los microservicios, las lambdas y la plataforma compartida (EventBridge,
RDS, S3), con los tres ejes narrativos —ingesta, knowledge tracing y event-driven— pintados con solo
los flujos esenciales.

!!! note "Hay dos versiones del C4"
    [`SWARD_C4_componentes_shortpaper.dsl`](diagramas/SWARD_C4_componentes_shortpaper.dsl) (reducido,
    para el *short paper*) y [`SWARD_C4_completo.dsl`](diagramas/SWARD_C4_completo.dsl) (detallado,
    para la memoria de tesis). Se renderizan igual (Structurizr Lite / CLI).

### Cómo renderizarlo

=== "Structurizr Lite (interactivo)"

    Recomendado para explorar. Monta el directorio actual y abre <http://localhost:8080>:

    ```bash
    docker run -it --rm -p 8080:8080 \
      -v "$PWD":/usr/local/structurizr \
      structurizr/lite
    ```

    Structurizr Lite busca un `workspace.dsl` por defecto; si tu archivo se llama distinto,
    renómbralo o crea un enlace:

    ```bash
    ln -sf SWARD_C4_componentes_shortpaper.dsl workspace.dsl
    ```

=== "Structurizr CLI (exportar)"

    Para exportar a imagen o Mermaid para el paper:

    ```bash
    structurizr-cli export \
      -workspace SWARD_C4_componentes_shortpaper.dsl \
      -format mermaid
    # también: -format plantuml | png | svg (según necesites)
    ```

!!! tip
    El propio `.dsl` lleva estos comandos documentados en su cabecera de comentario.

---

## Diagramas de clases UML (PlantUML) — arquitectura hexagonal

La carpeta `plantuml/` contiene los **diagramas de clases** de cada microservicio, estructurados por
las capas de la **arquitectura hexagonal**: `domain` (entidades, value objects, puertos),
`application` (casos de uso) e `infrastructure` (adaptadores `in_`/`out_`).

| Archivo | Microservicio / vista |
|---------|------------------------|
| [`Microservicio_de_Usuarios.puml`](diagramas/plantuml/Microservicio_de_Usuarios.puml) | MS Usuarios (auth, registro, roles, notificaciones) |
| [`Microservicio_de_Integracion_LMS.puml`](diagramas/plantuml/Microservicio_de_Integracion_LMS.puml) | MS Integración LMS (sincronización Moodle) |
| [`Microservicio_de_Cursos_y_Recursos.puml`](diagramas/plantuml/Microservicio_de_Cursos_y_Recursos.puml) | MS Cursos y Recursos (catálogo) |
| [`Microservicio_de_Trazabilidad.puml`](diagramas/plantuml/Microservicio_de_Trazabilidad.puml) | MS Trazabilidad (interacciones, dashboard docente) |
| [`Microservicio_de_Recomendacion.puml`](diagramas/plantuml/Microservicio_de_Recomendacion.puml) | MS Recomendación (SAKT + material LLM) |
| [`Microservicio_XAI.puml`](diagramas/plantuml/Microservicio_XAI.puml) | MS XAI (explicaciones + alertas) |
| [`Procesamiento_asincrono_con_Lambda_EventBridge_y_SQS.puml`](diagramas/plantuml/Procesamiento_asincrono_con_Lambda_EventBridge_y_SQS.puml) | Flujo event-driven (lambdas + EventBridge + SQS) |
| [`Vista_general_hexagonal_por_microservicio.puml`](diagramas/plantuml/Vista_general_hexagonal_por_microservicio.puml) | Vista general del patrón hexagonal aplicado |
| [`00_Clases_Hexagonal_combinado.puml`](diagramas/plantuml/00_Clases_Hexagonal_combinado.puml) | Versión combinada (todos en un solo archivo) |

### Cómo renderizar PlantUML

=== "VS Code (recomendado)"

    Extensión *PlantUML* (jebbs) → abrir el `.puml` → `Alt+D` (preview) o exportar a PNG/SVG.

=== "Servidor web (sin instalar nada)"

    Pegar el contenido en <https://www.plantuml.com/plantuml> → descargar PNG/SVG.

=== "CLI local (requiere Java)"

    ```bash
    # instala el jar de plantuml (o brew install plantuml) y exporta toda la carpeta
    plantuml -tsvg plantuml/*.puml        # SVG vectorial (ideal para LaTeX/web)
    plantuml -tpng plantuml/*.puml        # PNG para Word
    ```

!!! info
    Se incluye solo la **fuente** `.puml` (editable y versionable); las imágenes se generan con
    cualquiera de las opciones anteriores. Es la contraparte UML del C4: el C4 muestra la
    arquitectura **entre** servicios; estos diagramas muestran las clases **dentro** de cada servicio.

---

## Integración con Moodle (flujo de ingesta)

Flujo de datos desde Moodle hasta SAKT, según la arquitectura real de SWARD:
`lambda moodle-sync → ms-integracion-lms → Moodle REST API → PostgreSQL → EventBridge → SAKT`.

![Diagrama de integración con Moodle](diagramas/diagrama_moodle.svg){ width="380" }

> Fuentes para regenerarlo (TikZ) en [DKT y pyKT](diagramas-dkt.md#diagrama-integracion-con-moodle-flujo-de-ingesta).

---

## Flujo de la librería pyKT

Pipeline de *benchmarking* de Knowledge Tracing: del dataset crudo a la evaluación del modelo
(preprocesamiento → split → modelo KT → entrenamiento → métricas AUC/ACC).

![Diagrama del flujo pyKT](diagramas/diagrama_pykt.svg){ width="640" }

> Fuentes (Mermaid y TikZ) y el **pseudocódigo del DKT** en [DKT y pyKT](diagramas-dkt.md).

!!! note "SVG vs PNG"
    `diagrama_moodle.*` y `diagrama_pykt.*` ya están **renderizados**. El SVG es vectorial (no
    pixela, ideal para LaTeX/web); el PNG ([Moodle](diagramas/diagrama_moodle.png) ·
    [pyKT](diagramas/diagrama_pykt.png)) es para Word u herramientas que no aceptan SVG.

---

## Pseudocódigo y figuras para el paper

La página [DKT y pyKT](diagramas-dkt.md) contiene:

- El **pseudocódigo del DKT** (entrenamiento e inferencia), con la codificación one-hot `2M`,
  la pérdida BCE y las métricas (AUC, Accuracy).
- La **versión LaTeX** (`algorithm2e`) del algoritmo, lista para Overleaf → PDF/imagen.
- El **flujo pyKT** en **Mermaid** (para mermaid.live) y en **TikZ** (horizontal y vertical, para
  *short paper* a 1 o 2 columnas IEEE/ACM/Springer).
- Una variante "fiel al repo pykt-toolkit" (split K-Fold dentro de `data_preprocess.py`,
  entrenamiento con `wandb`, ajuste de hiperparámetros opcional).

**Render rápido:**

- **Mermaid** → pegar el bloque en <https://mermaid.live> → *Actions → Export → PNG/SVG*.
- **LaTeX/TikZ** → pegar en un *Blank Project* de <https://overleaf.com> → *Recompile* →
  *Download PDF* (con `standalone` el PDF sale recortado al diagrama).
