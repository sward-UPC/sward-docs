# Diagramas de SWARD

Esta carpeta reúne los diagramas del proyecto SWARD usados en la tesis y el *short paper*.

| Archivo | Qué representa | Formato |
|---------|----------------|---------|
| [`SWARD_C4_componentes_shortpaper.dsl`](./SWARD_C4_componentes_shortpaper.dsl) | **C4 reducido** (vista de contenedores condensada para el *short paper*): usuarios, los 6 microservicios, las lambdas de ingesta + event-driven, y los 3 flujos esenciales. | Structurizr DSL |
| [`SWARD_C4_completo.dsl`](./SWARD_C4_completo.dsl) | **C4 completo** (contexto + contenedores detallados): la versión extensa de la arquitectura, con todos los elementos y relaciones. | Structurizr DSL |
| [`plantuml/`](./plantuml/) | **Diagramas de clases (UML) por microservicio**, organizados según la **arquitectura hexagonal** (domain / application / ports / infrastructure): uno por cada uno de los 6 microservicios + el procesamiento asíncrono (Lambda/EventBridge/SQS) + una vista general del patrón hexagonal. | PlantUML (`.puml`) |
| [`diagrama_moodle.svg`](./diagrama_moodle.svg) / [`.png`](./diagrama_moodle.png) | **Integración con Moodle** (flujo de ingesta): `EventBridge schedule → lambda moodle-sync → ms-integracion-lms → Moodle REST → PostgreSQL → EventBridge → SAKT`. | SVG / PNG |
| [`diagrama_pykt.svg`](./diagrama_pykt.svg) / [`.png`](./diagrama_pykt.png) | **Flujo de la librería pyKT**: dataset crudo → preprocesamiento → split → modelo KT (DKT/SAKT) → entrenamiento → evaluación. | SVG / PNG |
| [`diagramas_dkt_pykt.md`](./diagramas_dkt_pykt.md) | **Pseudocódigo del DKT** (Deep Knowledge Tracing) + versiones LaTeX/TikZ y Mermaid del flujo pyKT, listas para Overleaf y mermaid.live. | Markdown |

---

## El diagrama C4 (Structurizr)

`SWARD_C4_componentes_shortpaper.dsl` está escrito en **Structurizr DSL** (modelo C4, vista de
contenedores). Es la figura de referencia de la arquitectura: muestra los dos tipos de usuario
(estudiante, docente), todos los microservicios, las lambdas y la plataforma compartida (EventBridge,
RDS, S3), con los tres ejes narrativos —ingesta, knowledge tracing y event-driven— pintados con solo
los flujos esenciales.

### Cómo renderizarlo

**Opción A — Structurizr Lite (interactivo, recomendado para explorar):**

```bash
# Desde esta carpeta (diagramas/), monta el directorio actual y abre http://localhost:8080
docker run -it --rm -p 8080:8080 \
  -v "$PWD":/usr/local/structurizr \
  structurizr/lite
```

Structurizr Lite busca un `workspace.dsl` por defecto; si tu archivo se llama distinto, renómbralo o
crea un enlace:

```bash
ln -sf SWARD_C4_componentes_shortpaper.dsl workspace.dsl
```

**Opción B — Structurizr CLI (exportar a imagen/Mermaid para el paper):**

```bash
structurizr-cli export \
  -workspace SWARD_C4_componentes_shortpaper.dsl \
  -format mermaid
# también: -format plantuml | png | svg (según necesites)
```

> El propio `.dsl` lleva estos comandos documentados en su cabecera de comentario.

> Hay **dos** versiones del C4: [`SWARD_C4_componentes_shortpaper.dsl`](./SWARD_C4_componentes_shortpaper.dsl)
> (reducido, para el *short paper*) y [`SWARD_C4_completo.dsl`](./SWARD_C4_completo.dsl) (detallado, para
> la memoria de tesis). Se renderizan igual (Structurizr Lite / CLI).

---

## Diagramas de clases UML (PlantUML) — arquitectura hexagonal

La carpeta [`plantuml/`](./plantuml/) contiene los **diagramas de clases** de cada microservicio,
estructurados por las capas de la **arquitectura hexagonal** (ver [`../../HEXAGONAL.md`](../../) en el
proyecto): `domain` (entidades, value objects, puertos), `application` (casos de uso) e
`infrastructure` (adaptadores `in_`/`out_`).

| Archivo | Microservicio / vista |
|---------|------------------------|
| `Microservicio_de_Usuarios.puml` | MS Usuarios (auth, registro, roles, notificaciones) |
| `Microservicio_de_Integracion_LMS.puml` | MS Integración LMS (sincronización Moodle) |
| `Microservicio_de_Cursos_y_Recursos.puml` | MS Cursos y Recursos (catálogo) |
| `Microservicio_de_Trazabilidad.puml` | MS Trazabilidad (interacciones, dashboard docente) |
| `Microservicio_de_Recomendacion.puml` | MS Recomendación (SAKT + material LLM) |
| `Microservicio_XAI.puml` | MS XAI (explicaciones + alertas) |
| `Procesamiento_asincrono_con_Lambda_EventBridge_y_SQS.puml` | Flujo event-driven (lambdas + EventBridge + SQS) |
| `Vista_general_hexagonal_por_microservicio.puml` | Vista general del patrón hexagonal aplicado |
| `00_Clases_Hexagonal_combinado.puml` | Versión combinada (todos en un solo archivo) |

### Cómo renderizar PlantUML

**Opción A — VS Code (recomendado):** extensión *PlantUML* (jebbs) → abrir el `.puml` →
`Alt+D` (preview) o exportar a PNG/SVG.

**Opción B — servidor PlantUML (sin instalar nada):** pegar el contenido en
<https://www.plantuml.com/plantuml> → descargar PNG/SVG.

**Opción C — CLI local (requiere Java):**

```bash
# instala el jar de plantuml (o brew install plantuml) y exporta toda la carpeta
plantuml -tsvg plantuml/*.puml        # SVG vectorial (ideal para LaTeX/web)
plantuml -tpng plantuml/*.puml        # PNG para Word
```

> Se incluye solo la **fuente** `.puml` (editable y versionable); las imágenes se generan con
> cualquiera de las opciones anteriores. Es la contraparte UML del C4: el C4 muestra la
> arquitectura **entre** servicios; estos diagramas muestran las clases **dentro** de cada servicio.

---

## Los diagramas SVG/PNG (Moodle y pyKT)

`diagrama_moodle.*` y `diagrama_pykt.*` ya están **renderizados** (listos para insertar en el
documento). El SVG es vectorial (no pixela, ideal para LaTeX/web); el PNG es para Word u herramientas
que no aceptan SVG. Las fuentes para regenerarlos (Mermaid / TikZ) están en
[`diagramas_dkt_pykt.md`](./diagramas_dkt_pykt.md).

---

## Pseudocódigo y figuras para el paper

[`diagramas_dkt_pykt.md`](./diagramas_dkt_pykt.md) contiene:

- El **pseudocódigo del DKT** (entrenamiento e inferencia), con la codificación one-hot `2M`,
  la pérdida BCE y las métricas (AUC, Accuracy).
- La **versión LaTeX** (`algorithm2e`) del algoritmo, lista para Overleaf → PDF/imagen.
- El **flujo pyKT** en **Mermaid** (para mermaid.live) y en **TikZ** (horizontal y vertical, para
  *short paper* a 1 o 2 columnas IEEE/ACM/Springer).
- Una variante "fiel al repo pykt-toolkit" (split K-Fold dentro de `data_preprocess.py`, entrenamiento
  con `wandb`, ajuste de hiperparámetros opcional).

**Render rápido:**
- **Mermaid** → pegar el bloque en <https://mermaid.live> → *Actions → Export → PNG/SVG*.
- **LaTeX/TikZ** → pegar en un *Blank Project* de <https://overleaf.com> → *Recompile* →
  *Download PDF* (con `standalone` el PDF sale recortado al diagrama).
