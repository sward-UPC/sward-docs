---
id: migraciones
title: Migraciones de base de datos — Alembic
sidebar_label: Migraciones (Alembic)
---

# Migraciones de base de datos — Alembic

> **Por qué importa.** Antes, cada microservicio creaba/actualizaba su esquema **en el arranque del
> contenedor**: un `Base.metadata.create_all` más una lista de `ALTER TABLE ... ADD COLUMN IF NOT
> EXISTS` incrustada en `main.py`. Eso significa que el esquema era "lo que el código aplicara al
> bootear": sin versionado, sin historial, sin rollback, y con DDL frágil corriendo en cada inicio.
> Los **6 microservicios** migraron a **Alembic**: el esquema queda versionado, los cambios son
> explícitos y reproducibles, y el arranque ya no muta la base de datos.

---

## 1. El patrón (idéntico en los 6 microservicios)

`sward-ms-trazabilidad` es la **plantilla canónica**; los demás replican exactamente la misma forma.

- **Alembic en modo async**: `migrations/env.py` abre un engine `asyncpg` y lee la URL de
  `settings.database_url` (la misma fuente que la app — no se hardcodea).
- **`version_table` por servicio**: cada microservicio versiona en su propia tabla
  (`alembic_version_<servicio>`). Esto permite que **convivan en la BD compartida de dev** sin
  pisarse, y funciona igual en prod (donde cada uno tiene su BD separada).
- **Baseline idempotente**: la primera revisión (`0001_baseline`) adopta el esquema existente sin
  recrear ni borrar nada.
- **Migración en el arranque**: el `Dockerfile` corre `alembic upgrade head` **antes** de `uvicorn`.

---

## 2. Archivos que añade cada repo

```text
alembic.ini                      # config; script_location=migrations, URL leída en env.py
migrations/
  env.py                         # entorno async: settings.database_url + version_table por servicio
  script.py.mako                 # plantilla de nuevas revisiones
  versions/
    0001_baseline.py             # baseline idempotente (adopta el esquema actual)
```

**`migrations/env.py`** (núcleo): usa `create_async_engine(settings.database_url)` y configura
`version_table = "alembic_version_<servicio>"` y `target_metadata = Base.metadata`.

**`Dockerfile`** — el entrypoint aplica migraciones y luego arranca la API:

```dockerfile
COPY alembic.ini .
COPY migrations/ migrations/
COPY src/ src/
...
CMD ["sh", "-c", "alembic upgrade head && uvicorn src.infrastructure.adapters.in_.main:app --host 0.0.0.0 --port 8000"]
```

El `lifespan` de `main.py` ya **no** toca el esquema: solo `yield` + `await engine.dispose()`.

---

## 3. El baseline idempotente (clave: no borra tu data)

La revisión `0001_baseline` no escribe DDL a mano; reusa los modelos como fuente de verdad con
`checkfirst=True`:

```python
def upgrade() -> None:
    bind = op.get_bind()
    # checkfirst=True -> idempotente: salta tablas ya existentes.
    Base.metadata.create_all(bind=bind, checkfirst=True)

def downgrade() -> None:
    Base.metadata.drop_all(bind=op.get_bind())
```

**Qué pasa al aplicarlo:**

| Escenario | Resultado |
|-----------|-----------|
| BD **nueva** (vacía) | Crea todas las tablas del modelo desde cero. |
| BD **existente** con datos (dev/prod actual) | No recrea nada (las tablas ya existen) → solo registra la versión en `alembic_version_<servicio>`. **Cero `DROP`/`DELETE`/`TRUNCATE`.** |

> **No requiere `alembic stamp` manual.** Como el baseline es idempotente, `alembic upgrade head`
> sobre una BD que ya tiene las tablas simplemente registra la versión y sigue. Esto evita el
> crash-loop típico de "adoptar Alembic en una BD existente".

> **Validado en vivo** en trazabilidad — el log de ECS mostró
> `Running upgrade -> 0001_baseline` sin ninguna sentencia destructiva.

---

## 4. Cómo crear una migración nueva (a partir de aquí)

Todo cambio de esquema (columna, tabla, índice) va en **su propia revisión**, nunca como DDL inline
en el arranque.

```bash
# 1. Edita el modelo SQLAlchemy en src/infrastructure/db/models/...
# 2. Autogenera la revisión comparando modelos vs BD:
alembic revision --autogenerate -m "agrega columna X a tabla Y"
# 3. REVISA el script generado en migrations/versions/ (el autogenerate no es infalible).
# 4. Aplica:
alembic upgrade head
```

Para datos base / seeds (p.ej. roles), van dentro del `upgrade()` de una revisión y deben ser
**idempotentes** (ver el caso de `ms-usuarios` abajo).

---

## 5. `version_table` por microservicio

| Microservicio | `version_table` |
|---------------|-----------------|
| trazabilidad | `alembic_version_trazabilidad` |
| usuarios | `alembic_version_usuarios` |
| recomendacion | `alembic_version_recomendacion` |
| integracion-lms | `alembic_version_integracion_lms` |
| cursos-recursos | `alembic_version_cursos_recursos` |
| xai | `alembic_version_xai` |

Cada servicio gestiona **solo sus propias tablas** y su propia tabla de versión, por eso pueden
compartir una misma instancia RDS en dev sin interferir.

---

## 6. Comandos útiles

```bash
# Ver el historial de revisiones y cuál es la cabeza (head)
alembic history
alembic heads

# Ver en qué revisión está la BD actual
alembic current

# Dry-run: muestra el SQL que ejecutaría, SIN tocar la BD
alembic upgrade head --sql

# Aplicar / revertir
alembic upgrade head
alembic downgrade -1
```

> Comprobación rápida tras un deploy (requiere perfil con permisos de logs):
> ```bash
> aws logs tail /ecs/sward --since 10m --profile sward | grep -i alembic
> ```

---

## 7. Gotchas y notas

- **`downgrade` borra tablas.** El `downgrade()` del baseline hace `drop_all`. **Nunca** lo corras en
  prod: el entrypoint solo ejecuta `upgrade head` (jamás downgrade), así que en el deploy no se
  dispara. Está ahí solo por convención de Alembic.
- **Seeds en `ms-usuarios`.** Los seeds de roles y del admin inicial (antes en el lifespan, en cada
  arranque) se movieron al `upgrade()` del baseline. Son **idempotentes** (verifican existencia antes
  de insertar) y corren una vez al aplicar `0001`. El admin solo se siembra si `ADMIN_SEED_PASSWORD`
  está configurado.
- **`deploy` puede divergir de `main`.** Si la rama `deploy` acumuló fixes que no volvieron a `main`,
  un refactor que toque los mismos archivos genera conflicto al hacer el PR `main → deploy`. Pasó en
  `ms-xai`: se resolvió con un PR de reconciliación (mergear `deploy` en `main` resolviendo el
  conflicto y preservando los fixes) **antes** de mergear `main → deploy`.
- **Concurrencia en ECS.** Si un servicio corre con varias tareas, todas ejecutan `alembic upgrade
  head` al arrancar. El baseline es idempotente, pero para migraciones futuras pesadas conviene
  considerar un paso de migración dedicado en el deploy.

---

## 8. Resumen

| Antes | Ahora |
|-------|-------|
| `create_all` + `ALTER TABLE` inline en `main.py` | Migraciones versionadas con Alembic |
| Esquema mutado en cada arranque | Esquema aplicado por `alembic upgrade head` en el entrypoint |
| Sin historial ni rollback | Revisiones explícitas, `history`/`current`/`downgrade` |
| Riesgo de DDL frágil en el boot | Baseline idempotente que adopta la BD sin borrar data |
