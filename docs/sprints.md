---
id: sprints
title: Sprints de TP2
sidebar_label: Sprints
---

# Sprints de TP2

Registro de los sprints del ciclo 2026-20, con la evidencia que los sostiene: los
commits de los diecinueve repositorios de la organización. **Cada cifra de esta
página se cuenta del historial**, no se declara a mano; el comando que la produce
está al final.

Las semanas son las del cronograma del curso. La semana 7 es la del **11 de
octubre**, que es la sustentación parcial, y de ahí sale el resto del calendario.

| Fase | Semanas | Fechas |
|---|---|---|
| Inception | S0 – S3 | hasta el 13 de septiembre |
| **Sprint 1** | S4 – S6 | 14 de septiembre – 4 de octubre |
| **Sprint 2** | S7 – S9 | 5 – 25 de octubre |
| Sprint 3 | S10 – S12 | 26 de octubre – 15 de noviembre |
| Sprint 4 | S13 – S16 | 16 de noviembre – 13 de diciembre |

---

## Inception · hasta el 13 de septiembre

**Objetivo.** Recuperar el proyecto del integrante anterior, dejarlo reproducible
y medir de qué se partía.

**834 commits**, de los cuales la mayoría son el código base heredado. Lo hecho en
esta fase: respaldo de los diecinueve repositorios con manifiesto de procedencia,
entorno local completo y reproducible, los primeros trece defectos corregidos, la
comparación de modelos con validación cruzada y la primera medición de fidelidad.

**Lo que dejó por escrito.** Que el 70,6 % de fidelidad medido el 8 de septiembre
era inválido —el modelo se servía con un formato de entrada distinto al del
entrenamiento— y que SAKT no es significativamente mejor que DKT, de modo que se
justifica por interpretabilidad y no por precisión.

---

## Sprint 1 · 14 de septiembre – 4 de octubre

**Objetivo.** Dejar el sistema en condiciones de que lo use gente de fuera, y
completar el objetivo específico 4 al 100 %, que es lo que el cronograma pide para
la semana 7.

### S4 · 14 – 20 de septiembre · 24 commits

| Repositorio | Commits |
|---|---|
| `sward-ms-recomendacion` | 5 |
| `sward-infra` | 4 |
| `sward-moodle-test` | 4 |
| `sward-ms-integracion-lms` | 3 |
| `sward-ms-xai` | 3 |
| `sward-frontend` | 2 |
| `sward-ms-usuarios` | 2 |
| `sward-model-training` | 1 |

Entorno de las sesiones con el aporte dentro, 4 620 interacciones sincronizadas
desde Moodle, defectos 14 a 22 corregidos —entre ellos el que invalidaba la
medición de fidelidad y la mitad de las interacciones que se perdía al
sincronizar—, y las latencias medidas: recomendación 35 ms de mediana, explicación
144 ms, el 98 % por debajo de los 500 ms que pide HU-033.

### S5 · 21 – 27 de septiembre · 177 commits

| Repositorio | Commits |
|---|---|
| `sward-moodle-test` | 29 |
| `sward-frontend` | 23 |
| `sward-infra` | 22 |
| `sward-ms-integracion-lms` | 18 |
| `sward-ms-usuarios` | 17 |
| `sward-local` | 14 |
| `sward-ms-cursos-recursos` | 7 |
| `sward-ms-trazabilidad` | 7 |
| `sward-ms-recomendacion` | 6 |
| `sward-model-training` | 3 |
| `sward-ms-xai` | 2 |
| Las tres lambdas | 3 |

La semana de más trabajo del ciclo. Cuatro entregas:

**El aula virtual y la aplicación que verán los participantes.** Dos cursos
completos —Estadística y Matemática Financiera, seis temas cada uno, 36
cuestionarios—, el modelo reentrenado únicamente con sus doce conceptos, y la
escala vigesimal peruana en todo el sistema.

**El alta de participantes entra al sistema.** Hasta el 24 de septiembre se hacía
con un formulario de Google y un script corrido a mano. Ahora el registro de SWARD
crea la cuenta en Moodle, matricula en los dos cursos y guarda el consentimiento.
El formulario queda retirado: el registro es la única vía de alta.

**El sistema en internet.** Once stacks desplegados en AWS con infraestructura como
código: red, secretos, almacenamiento, registro de imágenes, base, siete servicios
en Fargate, cinco lambdas, CloudFront y el aula virtual. Probado de punta a punta
contra la nube.

**Quince defectos encontrados usándolo.** Ninguno aparecía leyendo el código.
Entre ellos: el separador decimal que habría bloqueado a los 30 participantes en la
primera pregunta, tres contraseñas distintas para entrar a dos sitios, y el campo
que dice qué docente dicta cada curso, que **nadie escribía**, de modo que el panel
del profesor habría salido vacío el día de la sesión.

### S6 · 28 de septiembre – 4 de octubre · en ejecución

El rediseño del estudio de dos fases a **una sola sesión autoadministrada**,
obligado por lo que la docente puede pedirle a su grupo; el formulario de la
validación; y el video demostrativo para los expertos.

### Cierre del Sprint 1

Se cierra el **4 de octubre** con la etiqueta `tp2-sprint-1` en los repositorios
con actividad, apuntando al último commit de la semana 6.

---

## Sprint 2 · 5 – 25 de octubre

**Objetivo.** Ejecutar la validación con usuarios y convertir sus resultados en el
Capítulo 3.

**Alcance planificado.** La ventana con los 30 estudiantes y el docente; el
reentrenamiento del modelo con sus interacciones reales; la nueva medición de
fidelidad sobre esos datos; el análisis de los tres cuestionarios —SUS, comprensión
de las explicaciones, y tolerancia al error y eficiencia percibida—; y las cinco
fichas de juicio de expertos firmadas.

**Hito dentro del sprint.** La sustentación parcial (TB1) cae en la semana 7, es
decir dentro de este sprint y no al final del anterior. En ese momento el Sprint 1
está cerrado y el Sprint 2 recién empezado.

---

## Cómo se cuentan estas cifras

Desde la carpeta que contiene los repositorios:

```bash
for d in */; do
  [ -d "$d/.git" ] || continue
  n=$(git -C "$d" log --branches --since=2026-09-21 --until="2026-09-27 23:59" --oneline | wc -l)
  [ "$n" != "0" ] && printf "%-28s %s\n" "${d%/}" "$n"
done
```

Se cuentan todas las ramas, no solo `main`, porque el trabajo de integración vive
en ramas de tema que se mezclan al cerrar. Los merges de `main` a `deploy` sí
cuentan: son la publicación de las imágenes que consume la nube, y sin ellas el
despliegue corre código viejo — cosa que pasó, y por eso se vigila.
