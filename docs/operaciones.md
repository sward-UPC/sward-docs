---
id: operaciones
title: Operaciones — Encender y apagar la infraestructura
sidebar_label: Operaciones
---

# Operaciones — Encender y apagar la infraestructura

> **Por qué importa.** La infraestructura de SWARD (ECS Fargate, RDS PostgreSQL, lambdas con
> concurrencia reservada) **cobra mientras está encendida**, aunque nadie la use. RDS y ECS son los
> componentes más caros. Para una tesis/proyecto que no necesita estar disponible 24/7, **apagar la
> infra cuando no se usa es el mayor ahorro de costos**. Por eso `sward-infra` incluye dos workflows
> de GitHub Actions que prenden y apagan todo de forma ordenada, más un apagado nocturno automático.

---

## 1. Encender la infraestructura

Workflow: **`start.yml`** ("Encender infraestructura") en el repo `sward-UPC/sward-infra`.

```bash
gh workflow run start.yml --repo sward-UPC/sward-infra
```

**Qué hace, en orden** (el orden importa: la BD debe estar lista antes de que arranquen los
servicios que dependen de ella):

1. **Inicia RDS** (arranca la instancia detenida).
2. **Espera a que RDS esté disponible** (la BD tarda en pasar de `stopped` a `available`).
3. **Escala ECS a 1** (vuelve a levantar los servicios de los microservicios, `desiredCount = 1`).
4. **Restaura la concurrencia de las lambdas** (vuelve a dejarlas operativas).

Tras esto la plataforma queda accesible vía CloudFront + ALB.

---

## 2. Apagar la infraestructura

Workflow: **`stop.yml`** en `sward-UPC/sward-infra`.

```bash
gh workflow run stop.yml --repo sward-UPC/sward-infra
```

**Qué hace, en orden** (inverso al de encendido: primero se bajan los consumidores, luego la BD):

1. **Escala ECS a 0** (`desiredCount = 0`: detiene las tareas Fargate, deja de cobrar cómputo).
2. **Detiene RDS** (la BD pasa a `stopped`).
3. **Lambdas a 0** (concurrencia reservada en 0, para que no se ejecuten).

> **Stop automático nocturno.** Existe un **cron** que ejecuta el apagado por la noche, de modo que
> si alguien olvidó apagar la infra, igual no queda encendida toda la noche generando costos. El
> encendido es siempre **manual** (cuando se va a trabajar); el apagado tiene red de seguridad
> automática.

---

## 3. Ver el estado / consultar ejecuciones

```bash
# Listar últimas ejecuciones de los workflows de start/stop
gh run list --repo sward-UPC/sward-infra --workflow start.yml
gh run list --repo sward-UPC/sward-infra --workflow stop.yml

# Ver el detalle de una ejecución
gh run view <run-id> --repo sward-UPC/sward-infra --log
```

---

## 4. Modo `dev` — importante no malinterpretarlo

- En modo dev se usa **una sola instancia RDS compartida** llamada **`sward`** (en lugar de una por
  microservicio), para abaratar.
- El flag **`is_dev`** del CDK **solo cambia el tamaño/forma de la infra** (instancias más pequeñas,
  RDS compartida). **NO activa ningún mock.**
- El **`ENVIRONMENT` que ven los contenedores ECS es siempre `"production"`**. Es decir: aunque la
  infra sea "dev" (más barata), las aplicaciones corren en modo producción y se comportan igual que
  en un despliegue real. No hay que confundir "infraestructura dev" con "app en modo prueba".

---

## 5. Resumen operativo

| Acción | Comando | Efecto |
|--------|---------|--------|
| Encender | `gh workflow run start.yml --repo sward-UPC/sward-infra` | RDS up → espera → ECS=1 → lambdas restauradas |
| Apagar | `gh workflow run stop.yml --repo sward-UPC/sward-infra` | ECS=0 → RDS down → lambdas=0 |
| Apagado automático | *cron nocturno* | Igual que `stop.yml`, como red de seguridad |

**Regla práctica:** antes de empezar a trabajar, `start.yml`; al terminar, `stop.yml` (y si se
olvida, el cron lo apaga de noche).
