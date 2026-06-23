/*
 * ============================================================================
 *  SWARD - Diagrama C4 reducido (short paper) - v2 COMPACTO
 * ============================================================================
 *
 *  Que representa:
 *    Vista de CONTENEDORES condensada de SWARD (Sistema Web de Recomendacion
 *    Adaptativa y Explicable). Pensada para un SHORT PAPER: muestra los DOS
 *    usuarios, TODOS los microservicios y las lambdas de INGESTA + event-driven,
 *    con SOLO los flujos esenciales. Se omite a proposito lo accesorio (Redis,
 *    persistencia menor) para que la figura quepa y se lea.
 *
 *  Narrativa (3 ejes):
 *    1) Ingesta:        Moodle -> lambda-moodle-sync (cada 15 min) -> Integracion LMS -> BD.
 *    2) Knowledge tracing: Trazabilidad -> Recomendacion (SAKT desde S3) -> XAI.
 *    3) Event-driven:   servicios -> EventBridge -> lambdas (interacciones, alertas, notificaciones).
 *
 *  Como renderizar:
 *    Structurizr Lite:  docker run -it --rm -p 8080:8080 -v "$PWD":/usr/local/structurizr structurizr/lite
 *    Structurizr CLI:   structurizr-cli export -workspace SWARD_C4_componentes_shortpaper.dsl -format mermaid
 *
 *  Nota: cada microservicio tiene su PROPIA BD PostgreSQL (RDS); en la figura se
 *  agrupan en un unico contenedor "Bases de Datos" y se dibujan solo las
 *  escrituras centrales a la narrativa para no saturar.
 * ============================================================================
 */

workspace "SWARD - Vista reducida de microservicios" "Modelo C4 condensado y compacto para short paper" {

    !identifiers hierarchical

    model {
        estudiante = person "Estudiante" "Ve progreso, recomendaciones, explicaciones y notificaciones."
        docente = person "Docente" "Monitorea desempeno y riesgo; envia retroalimentacion."

        moodle = softwareSystem "Moodle (LMS)" "Cursos, actividades, calificaciones e interacciones." {
            tags "External System"
        }

        sistema = softwareSystem "SWARD" "Microservicios hexagonales (ECS) con procesamiento asincrono event-driven en AWS." {
            tags "Core System"

            frontend = container "App Web" "Interfaz de estudiantes y docentes (CloudFront + ALB)." "React" {
                tags "Frontend"
            }

            // ── Microservicios (ECS) ───────────────────────────────────────
            usuariosService = container "MS Usuarios" "Auth JWT, registro gated por Moodle, roles y notificaciones." "FastAPI (ECS)" {
                tags "Microservice"
            }
            lmsService = container "MS Integracion LMS" "Ingiere y expone cursos, notas e interacciones de Moodle." "FastAPI (ECS)" {
                tags "Microservice"
            }
            cursosService = container "MS Cursos y Recursos" "Catalogo de recursos; candidatos a recomendar." "FastAPI (ECS)" {
                tags "Microservice"
            }
            trazabilidadService = container "MS Trazabilidad" "Interacciones, progreso y dashboard docente." "FastAPI (ECS)" {
                tags "Microservice"
            }
            recomendacionService = container "MS Recomendacion" "Modelo SAKT + material generado (LLM/Bedrock); recomienda por formato." "Python/pyKT (ECS)" {
                tags "AI Service"
            }
            xaiService = container "MS XAI" "Explica predicciones (atencion) y registra alertas de riesgo." "Python (ECS)" {
                tags "AI Service"
            }

            // ── Lambdas de INGESTA ─────────────────────────────────────────
            lambdaMoodleSync = container "λ Moodle-Sync (ingesta)" "Programada 15 min: dispara la ingesta academica desde Moodle." "AWS Lambda" {
                tags "Ingest Lambda"
            }
            lambdaInteracciones = container "λ Interacciones (ingesta)" "Persiste interacciones academicas de forma asincrona." "AWS Lambda" {
                tags "Ingest Lambda"
            }

            // ── Lambdas event-driven ───────────────────────────────────────
            lambdaAlertas = container "λ Alertas" "Evalua riesgo y crea alertas explicables." "AWS Lambda" {
                tags "Lambda"
            }
            lambdaNotificaciones = container "λ Notificaciones" "Consume eventos y persiste notificaciones." "AWS Lambda" {
                tags "Lambda"
            }

            // ── Plataforma compartida ──────────────────────────────────────
            eventBus = container "EventBridge" "Bus de eventos de dominio (sward-event-bus)." "Amazon EventBridge" {
                tags "Event Bus"
            }
            storage = container "S3 (sward-models)" "Checkpoint del modelo SAKT." "Amazon S3" {
                tags "Storage"
            }
            // Nota: cada microservicio tiene su propia BD PostgreSQL (RDS); se omiten
            // en esta figura por compacidad (el foco es la topología y los flujos).
        }

        // ── Usuarios -> sistema ────────────────────────────────────────────
        estudiante -> sistema.frontend "Usa la app" "HTTPS"
        docente -> sistema.frontend "Usa la app" "HTTPS"
        sistema.frontend -> sistema.usuariosService "Auth y notificaciones" "REST"
        sistema.frontend -> sistema.trazabilidadService "Progreso y dashboard" "REST"
        sistema.frontend -> sistema.recomendacionService "Recomendaciones y material" "REST"
        sistema.frontend -> sistema.xaiService "Explicaciones" "REST"

        // ── Eje 1: INGESTA Moodle -> SWARD ─────────────────────────────────
        sistema.lambdaMoodleSync -> sistema.lmsService "Dispara ingesta (15 min)" "REST"
        sistema.lmsService -> moodle "Extrae cursos, notas e interacciones" "Moodle API"
        sistema.usuariosService -> sistema.lmsService "Valida identidad en Moodle (registro)" "REST"

        // ── Eje 2: KNOWLEDGE TRACING ───────────────────────────────────────
        sistema.recomendacionService -> sistema.trazabilidadService "Historial de interacciones (insumo SAKT)" "REST"
        sistema.recomendacionService -> sistema.cursosService "Recursos candidatos" "REST"
        sistema.recomendacionService -> sistema.storage "Carga checkpoint SAKT" "S3"
        sistema.recomendacionService -> sistema.xaiService "Explicacion de la prediccion" "REST"

        // ── Eje 3: EVENT-DRIVEN ────────────────────────────────────────────
        sistema.trazabilidadService -> sistema.eventBus "Interaccion, Feedback, Logro, Riesgo" "EventBridge"
        sistema.recomendacionService -> sistema.eventBus "RecomendacionGenerada" "EventBridge"
        sistema.usuariosService -> sistema.eventBus "UsuarioRegistrado" "EventBridge"
        sistema.eventBus -> sistema.lambdaInteracciones "Enruta interacciones (SQS)" "Rule"
        sistema.eventBus -> sistema.lambdaAlertas "Enruta riesgo/recomendacion" "Rule"
        sistema.eventBus -> sistema.lambdaNotificaciones "Enruta feedback/logros/alertas/registro" "Rule"
        sistema.lambdaAlertas -> sistema.eventBus "AlertaCreada" "EventBridge"
    }

    views {
        container sistema "contenedores-sward-reducido" {
            title "SWARD - Arquitectura de microservicios (vista reducida)"
            description "Usuarios, todos los microservicios y las lambdas de ingesta + event-driven. Flujos esenciales."
            include *
            autoLayout tb 200 110
        }

        styles {
            element "Person" {
                shape Person
                background "#08427B"
                color "#FFFFFF"
            }
            element "Core System" {
                background "#1168BD"
                color "#FFFFFF"
            }
            element "External System" {
                background "#999999"
                color "#FFFFFF"
            }
            element "Frontend" {
                background "#2E7D32"
                color "#FFFFFF"
            }
            element "Microservice" {
                background "#1976D2"
                color "#FFFFFF"
            }
            element "AI Service" {
                background "#6A1B9A"
                color "#FFFFFF"
            }
            element "Database" {
                shape Cylinder
                background "#EF6C00"
                color "#FFFFFF"
            }
            element "Storage" {
                shape Cylinder
                background "#F9A825"
                color "#000000"
            }
            element "Event Bus" {
                shape Pipe
                background "#5D4037"
                color "#FFFFFF"
            }
            element "Ingest Lambda" {
                shape Hexagon
                background "#E65100"
                color "#FFFFFF"
            }
            element "Lambda" {
                shape Hexagon
                background "#FF9900"
                color "#000000"
            }
            relationship "Relationship" {
                color "#707070"
                thickness 2
            }
        }
    }
}
