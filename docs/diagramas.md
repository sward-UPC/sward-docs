---
id: diagramas
title: Diagramas de SWARD
sidebar_label: Resumen
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';
import useBaseUrl from '@docusaurus/useBaseUrl';

# Diagramas de SWARD

Todos los diagramas del proyecto, **renderizados** en esta página. Las fuentes editables
(`.dsl` de Structurizr, `.puml` de PlantUML) están enlazadas bajo cada figura por si quieres
regenerarlas o modificarlas.

:::tip Cómo se renderizaron
Los SVG se generan desde la fuente con [Kroki](https://kroki.io) /
[Structurizr](https://structurizr.com) / [PlantUML](https://plantuml.com). Cada figura
incluye su fuente para reproducirla.
:::

---

## Arquitectura (modelo C4)

### Vista de contenedores — reducida (*short paper*)

Usuarios, los 6 microservicios, las lambdas de ingesta y event-driven, y los 3 flujos esenciales
(ingesta · knowledge tracing · event-driven). Layout vertical, compacto para una columna.

<figure>
  <img src={useBaseUrl('/diagramas/render/SWARD_C4_componentes_shortpaper.svg')} width="520" alt="C4 reducido de SWARD" />
  <figcaption>
    C4 · vista de contenedores reducida — fuente:{' '}
    <a href={useBaseUrl('/diagramas/SWARD_C4_componentes_shortpaper.dsl')}><code>SWARD_C4_componentes_shortpaper.dsl</code></a>
  </figcaption>
</figure>

### Vista de contenedores — completa

La versión extensa con todos los elementos y relaciones, para la memoria de tesis.

<figure>
  <img src={useBaseUrl('/diagramas/render/SWARD_C4_completo.svg')} width="760" alt="C4 completo de SWARD" />
  <figcaption>
    C4 · vista completa — fuente:{' '}
    <a href={useBaseUrl('/diagramas/SWARD_C4_completo.dsl')}><code>SWARD_C4_completo.dsl</code></a>
  </figcaption>
</figure>

---

## Integración con Moodle (flujo de ingesta)

`EventBridge schedule → λ moodle-sync → ms-integracion-lms → Moodle REST → PostgreSQL → EventBridge → SAKT`.

<figure>
  <img src={useBaseUrl('/diagramas/diagrama_moodle.svg')} width="420" alt="Integración con Moodle" />
  <figcaption>Pipeline de ingesta de datos académicos desde Moodle.</figcaption>
</figure>

## Flujo de la librería pyKT

Dataset crudo → preprocesamiento → split K-Fold → modelo KT (DKT/SAKT) → entrenamiento → evaluación.

<figure>
  <img src={useBaseUrl('/diagramas/diagrama_pykt.svg')} width="680" alt="Flujo pyKT" />
  <figcaption>Pipeline de entrenamiento/evaluación con pyKT.</figcaption>
</figure>

---

## Diagramas de clases (UML) — arquitectura hexagonal

Un diagrama de clases por microservicio, estructurado por las capas de la **arquitectura hexagonal**
(`domain` · `application` · `ports` · `infrastructure/adapters {'{'}in_, out_{'}'}`). El C4 muestra la
arquitectura **entre** servicios; estos muestran las clases **dentro** de cada uno.

<Tabs>
<TabItem value="usuarios" label="MS Usuarios" default>
  <figure>
    <img src={useBaseUrl('/diagramas/render/Microservicio_de_Usuarios.svg')} alt="Clases — MS Usuarios" />
    <figcaption>Auth JWT, registro gated por Moodle, roles y notificaciones.</figcaption>
  </figure>
</TabItem>
<TabItem value="integracion-lms" label="MS Integración LMS">
  <figure>
    <img src={useBaseUrl('/diagramas/render/Microservicio_de_Integracion_LMS.svg')} alt="Clases — MS Integración LMS" />
    <figcaption>Sincronización con Moodle (cursos, notas, interacciones).</figcaption>
  </figure>
</TabItem>
<TabItem value="cursos-recursos" label="MS Cursos y Recursos">
  <figure>
    <img src={useBaseUrl('/diagramas/render/Microservicio_de_Cursos_y_Recursos.svg')} alt="Clases — MS Cursos y Recursos" />
    <figcaption>Catálogo de cursos y recursos; candidatos a recomendar.</figcaption>
  </figure>
</TabItem>
<TabItem value="trazabilidad" label="MS Trazabilidad">
  <figure>
    <img src={useBaseUrl('/diagramas/render/Microservicio_de_Trazabilidad.svg')} alt="Clases — MS Trazabilidad" />
    <figcaption>Interacciones, progreso y dashboard docente.</figcaption>
  </figure>
</TabItem>
<TabItem value="recomendacion" label="MS Recomendación">
  <figure>
    <img src={useBaseUrl('/diagramas/render/Microservicio_de_Recomendacion.svg')} alt="Clases — MS Recomendación" />
    <figcaption>Modelo SAKT + material generado (LLM/Bedrock).</figcaption>
  </figure>
</TabItem>
<TabItem value="xai" label="MS XAI">
  <figure>
    <img src={useBaseUrl('/diagramas/render/Microservicio_XAI.svg')} alt="Clases — MS XAI" />
    <figcaption>Explicaciones (atención) y alertas de riesgo.</figcaption>
  </figure>
</TabItem>
</Tabs>

### Procesamiento asíncrono (event-driven)

<figure>
  <img src={useBaseUrl('/diagramas/render/Procesamiento_asincrono_con_Lambda_EventBridge_y_SQS.svg')} width="700" alt="Procesamiento asíncrono con Lambda, EventBridge y SQS" />
  <figcaption>Lambdas + EventBridge + SQS: ingesta y reacción a eventos de dominio.</figcaption>
</figure>

### Vista general del patrón hexagonal

<figure>
  <img src={useBaseUrl('/diagramas/render/Vista_general_hexagonal_por_microservicio.svg')} width="640" alt="Vista general hexagonal" />
  <figcaption>Capas y dependencias del patrón Ports &amp; Adapters aplicado a cada microservicio.</figcaption>
</figure>

<details>
<summary>Fuentes PlantUML y cómo regenerar</summary>

Las fuentes `.puml` editables están en
[`static/diagramas/plantuml/`](https://github.com/sward-UPC/sward-docs/tree/main/static/diagramas/plantuml)
(una por microservicio + el flujo async + la vista general + una versión combinada).

<Tabs>
<TabItem value="vscode" label="VS Code" default>
  Extensión *PlantUML* (jebbs) → abrir el `.puml` → `Alt+D` (preview) o exportar a SVG/PNG.
</TabItem>
<TabItem value="online" label="Sin instalar nada">
  Pegar el contenido en [www.plantuml.com/plantuml](https://www.plantuml.com/plantuml) y descargar SVG/PNG.
</TabItem>
<TabItem value="cli" label="CLI / Kroki">

```bash
# PlantUML local (requiere Java)
plantuml -tsvg static/diagramas/plantuml/*.puml
# o vía Kroki (POST con User-Agent de navegador)
curl -s -H "User-Agent: Mozilla/5.0" --data-binary @diagrama.puml \
  https://kroki.io/plantuml/svg -o diagrama.svg
```

</TabItem>
</Tabs>

</details>

<details>
<summary>Cómo renderizar el C4 (Structurizr)</summary>

<Tabs>
<TabItem value="lite" label="Structurizr Lite (interactivo)" default>

```bash
# desde static/diagramas/, abre http://localhost:8080
docker run -it --rm -p 8080:8080 -v "$PWD":/usr/local/structurizr structurizr/lite
ln -sf SWARD_C4_componentes_shortpaper.dsl workspace.dsl   # Lite busca workspace.dsl
```

</TabItem>
<TabItem value="cli" label="CLI / Kroki">

```bash
structurizr-cli export -workspace SWARD_C4_completo.dsl -format svg
# o Kroki:
curl -s -H "User-Agent: Mozilla/5.0" --data-binary @SWARD_C4_completo.dsl \
  https://kroki.io/structurizr/svg -o c4.svg
```

</TabItem>
</Tabs>

</details>

---

## Pseudocódigo del DKT y figuras para el paper

El pseudocódigo del **DKT** (con la versión LaTeX para Overleaf y el flujo pyKT en Mermaid/TikZ)
está en la página [**Pseudocódigo DKT**](diagramas-dkt.md), listo para el *short paper*.
