# Diagramas de SWARD

Esta carpeta reúne los diagramas del proyecto SWARD usados en la tesis y el *short paper*.

| Archivo | Qué representa | Formato |
|---------|----------------|---------|
| [`SWARD_C4_componentes_shortpaper.dsl`](./SWARD_C4_componentes_shortpaper.dsl) | **C4 reducido** (vista de contenedores condensada): usuarios, los 6 microservicios, las lambdas de ingesta + event-driven, y los 3 flujos esenciales. | Structurizr DSL |
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
