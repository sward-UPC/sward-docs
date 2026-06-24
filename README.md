# SWARD · Documentación central

![Tesis](https://img.shields.io/badge/proyecto-tesis-blueviolet)
![Privado](https://img.shields.io/badge/repo-privado-lightgrey)
![Docs](https://img.shields.io/badge/docs-Docusaurus-6d28d9)
![Cloud](https://img.shields.io/badge/cloud-AWS-orange)

Documentación de **SWARD** (*Sistema Web de Recomendación Adaptativa y Explicable*): un **tutor
adaptativo** sobre **Moodle** que usa **knowledge tracing** (SAKT entrenado con pyKT) para recomendar
el siguiente recurso de forma **explicable** (XAI), implementado como **microservicios hexagonales
event-driven** sobre AWS.

> Este repositorio (`sward-docs`) es la documentación central transversal del proyecto. Todo el
> contenido vive en [`docs/`](./docs/) y se publica como un sitio **Docusaurus** en GitHub Pages.

## Cómo ver la documentación

```bash
npm install
npm start
```

Abre <http://localhost:3000/sward-docs/>. Para generar el sitio estático:

```bash
npm run build     # salida en ./build
npm run serve     # sirve ./build localmente
```

Los diagramas (SVG/PNG, fuentes `.dsl` de Structurizr y `.puml` de PlantUML) viven en
[`static/diagramas/`](./static/diagramas/) y se sirven como archivos estáticos.

## Contenido

| Sección | Archivo |
|---------|---------|
| Inicio (landing) | [`docs/index.md`](./docs/index.md) |
| Arquitectura (6 microservicios, lambdas, AWS, 3 flujos) | [`docs/arquitectura.md`](./docs/arquitectura.md) |
| Operaciones (encender / apagar la infra) | [`docs/operaciones.md`](./docs/operaciones.md) |
| Runbook de GitHub secrets | [`docs/secrets-runbook.md`](./docs/secrets-runbook.md) |
| Diagramas (C4, UML hexagonal, Moodle, pyKT) | [`docs/diagramas.md`](./docs/diagramas.md) · [`docs/diagramas-dkt.md`](./docs/diagramas-dkt.md) |

## Organización

Todo el código vive en la organización **`sward-UPC`**, con un repositorio por componente
(`sward-ms-*`, `sward-lambda-*`, `sward-infra`, `sward-frontend`, `sward-model-training`,
`sward-shared`).
