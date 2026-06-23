# SWARD · Documentación central

![Tesis](https://img.shields.io/badge/proyecto-tesis-blueviolet)
![Privado](https://img.shields.io/badge/repo-privado-lightgrey)
![Docs](https://img.shields.io/badge/docs-MkDocs%20Material-526CFE)
![Cloud](https://img.shields.io/badge/cloud-AWS-orange)

Documentación de **SWARD** (*Sistema Web de Recomendación Adaptativa y Explicable*): un **tutor
adaptativo** sobre **Moodle** que usa **knowledge tracing** (SAKT entrenado con pyKT) para recomendar
el siguiente recurso de forma **explicable** (XAI), implementado como **microservicios hexagonales
event-driven** sobre AWS.

> Este repositorio (`sward-docs`) es la documentación central transversal del proyecto. Todo el
> contenido vive en [`docs/`](./docs/) y se publica como un sitio **MkDocs Material**.

## Cómo ver la documentación

```bash
pip install -r requirements.txt
mkdocs serve
```

Abre <http://localhost:8000>. Para generar el sitio estático:

```bash
mkdocs build --strict   # salida en ./site
```

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
