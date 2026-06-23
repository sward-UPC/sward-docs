workspace "Sistema Web de Recomendación Adaptativa" "Modelo C4 del sistema" {

    !identifiers hierarchical

    model {
        estudiante = person "Estudiante" "Consulta progreso, recomendaciones y explicaciones."
        docente = person "Docente" "Monitorea trazabilidad, desempeño y alertas."

        moodle = softwareSystem "Moodle LMS" "Provee cursos, actividades, calificaciones e interacciones." {
            tags "External System"
        }

        aws = softwareSystem "Amazon Web Services" "Infraestructura cloud para despliegue, cómputo, base de datos y almacenamiento." {
            tags "External System"
        }

        sistema = softwareSystem "Sistema Web de Recomendación Adaptativa y Explicable" "Sistema distribuido basado en microservicios, diseño hexagonal y procesamiento asíncrono." {
            tags "Core System"

            frontend = container "Aplicación Web" "Interfaz para estudiantes y docentes." "React.js" {
                tags "Frontend"
            }

            apiGateway = container "Application Load Balancer" "Punto de entrada para solicitudes del frontend; enruta por path a cada microservicio." "AWS Application Load Balancer" {
                tags "Gateway"
            }

            usuariosService = container "Microservicio de Usuarios" "Gestiona usuarios, roles y permisos." "FastAPI / Hexagonal" {
                tags "Microservice"

                usuariosRestController = component "Controlador REST" "Recibe solicitudes de autenticación, usuarios y permisos." "FastAPI Controller" {
                    tags "Inbound Adapter"
                }
                autenticarUsuarioUseCase = component "Caso de Uso: Autenticar Usuario" "Valida credenciales y genera sesión segura." "Application Service" {
                    tags "Application"
                }
                gestionarUsuarioUseCase = component "Caso de Uso: Gestionar Usuario" "Crea, actualiza y consulta usuarios." "Application Service" {
                    tags "Application"
                }
                gestionarRolUseCase = component "Caso de Uso: Gestionar Rol" "Administra roles y permisos de acceso." "Application Service" {
                    tags "Application"
                }
                usuarioDomain = component "Entidad Usuario" "Representa datos principales del usuario." "Domain Model" {
                    tags "Domain"
                }
                rolDomain = component "Entidad Rol" "Representa perfiles como estudiante, docente o administrador." "Domain Model" {
                    tags "Domain"
                }
                permisoDomain = component "Entidad Permiso" "Representa acciones autorizadas dentro del sistema." "Domain Model" {
                    tags "Domain"
                }
                authService = component "Servicio de Autenticación" "Valida credenciales, tokens y control de acceso." "Domain Service" {
                    tags "Domain"
                }
                usuariosRepository = component "Adaptador BD Usuarios" "Persiste usuarios, roles y permisos." "PostgreSQL Adapter" {
                    tags "Outbound Adapter"
                }
                tokenProvider = component "Proveedor de Tokens" "Genera y valida tokens de sesión." "JWT Provider" {
                    tags "Outbound Adapter"
                }
                usuariosEventPublisher = component "Publicador de Eventos" "Publica eventos de usuario autenticado o actualizado." "EventBridge Client" {
                    tags "Outbound Adapter"
                }
            }

            usuariosDb = container "BD Usuarios" "Almacena usuarios, roles y permisos." "PostgreSQL / Amazon RDS" {
                tags "Database"
            }

            cursosService = container "Microservicio de Cursos y Recursos" "Gestiona cursos, actividades y recursos educativos." "FastAPI / Hexagonal" {
                tags "Microservice"

                cursosRestController = component "Controlador REST" "Recibe solicitudes de cursos, actividades y recursos." "FastAPI Controller" {
                    tags "Inbound Adapter"
                }
                gestionarCursoUseCase = component "Caso de Uso: Gestionar Curso" "Crea, actualiza y consulta cursos." "Application Service" {
                    tags "Application"
                }
                gestionarActividadUseCase = component "Caso de Uso: Gestionar Actividad" "Administra actividades académicas." "Application Service" {
                    tags "Application"
                }
                gestionarRecursoUseCase = component "Caso de Uso: Gestionar Recurso" "Administra recursos educativos y metadatos." "Application Service" {
                    tags "Application"
                }
                buscarRecursosUseCase = component "Caso de Uso: Buscar Recursos Candidatos" "Obtiene recursos disponibles para recomendación." "Application Service" {
                    tags "Application"
                }
                cursoDomain = component "Entidad Curso" "Representa un curso académico." "Domain Model" {
                    tags "Domain"
                }
                actividadDomain = component "Entidad Actividad" "Representa actividades, evaluaciones y tareas." "Domain Model" {
                    tags "Domain"
                }
                recursoDomain = component "Entidad Recurso Educativo" "Representa contenido educativo recomendable." "Domain Model" {
                    tags "Domain"
                }
                cursosRepository = component "Adaptador BD Cursos" "Persiste cursos, actividades y metadatos." "PostgreSQL Adapter" {
                    tags "Outbound Adapter"
                }
                cursosStorageClient = component "Cliente S3" "Guarda y consulta archivos educativos." "S3 Client" {
                    tags "Outbound Adapter"
                }
                cursosMoodleClient = component "Cliente Integración LMS" "Obtiene cursos y actividades sincronizadas desde Moodle." "REST Client" {
                    tags "Outbound Adapter"
                }
                cursosEventPublisher = component "Publicador de Eventos" "Publica eventos de recursos actualizados." "EventBridge Client" {
                    tags "Outbound Adapter"
                }
            }

            cursosDb = container "BD Cursos y Recursos" "Almacena cursos, actividades y metadatos de recursos." "PostgreSQL / Amazon RDS" {
                tags "Database"
            }

            trazabilidadService = container "Microservicio de Trazabilidad" "Registra progreso e interacciones académicas." "FastAPI / Hexagonal" {
                tags "Microservice"

                trazabilidadRestController = component "Controlador REST" "Recibe solicitudes sobre progreso e interacciones." "FastAPI Controller" {
                    tags "Inbound Adapter"
                }
                registrarInteraccionUseCase = component "Caso de Uso: Registrar Interacción" "Registra respuestas, actividades y uso de recursos." "Application Service" {
                    tags "Application"
                }
                consultarProgresoUseCase = component "Caso de Uso: Consultar Progreso" "Obtiene el avance académico del estudiante." "Application Service" {
                    tags "Application"
                }
                calcularIndicadoresUseCase = component "Caso de Uso: Calcular Indicadores" "Calcula métricas de trazabilidad y desempeño." "Application Service" {
                    tags "Application"
                }
                interaccionDomain = component "Entidad Interacción Académica" "Representa respuestas, actividades y eventos de aprendizaje." "Domain Model" {
                    tags "Domain"
                }
                progresoDomain = component "Entidad Progreso Académico" "Representa avance, dominio y estado del estudiante." "Domain Model" {
                    tags "Domain"
                }
                trazabilidadRepository = component "Adaptador BD Trazabilidad" "Persiste progreso e interacciones académicas." "PostgreSQL Adapter" {
                    tags "Outbound Adapter"
                }
                trazabilidadMoodleClient = component "Cliente Integración LMS" "Obtiene datos académicos sincronizados desde Moodle." "REST Client" {
                    tags "Outbound Adapter"
                }
                trazabilidadEventPublisher = component "Publicador de Eventos" "Publica eventos de interacción académica." "EventBridge Client" {
                    tags "Outbound Adapter"
                }
            }

            trazabilidadDb = container "BD Trazabilidad" "Almacena progreso, respuestas e interacciones académicas." "PostgreSQL / Amazon RDS" {
                tags "Database"
            }

            recomendacionService = container "Microservicio de Recomendación" "Genera recomendaciones adaptativas con SAKT/pyKT." "Python / pyKT / Hexagonal" {
                tags "AI Service"

                recomendacionRestController = component "Controlador REST" "Recibe solicitudes de recomendación." "FastAPI Controller" {
                    tags "Inbound Adapter"
                }
                generarRecomendacionUseCase = component "Caso de Uso: Generar Recomendación" "Orquesta la generación de recomendaciones adaptativas." "Application Service" {
                    tags "Application"
                }
                obtenerEstadoConocimientoUseCase = component "Caso de Uso: Obtener Estado de Conocimiento" "Calcula el dominio estimado del estudiante." "Application Service" {
                    tags "Application"
                }
                saktModel = component "Modelo SAKT / pyKT" "Estima el estado de conocimiento usando interacciones académicas." "pyKT / Python" {
                    tags "Domain"
                }
                motorRecomendacion = component "Motor de Recomendación" "Selecciona recursos según progreso, dominio y necesidades." "Domain Service" {
                    tags "Domain"
                }
                recomendacionRepository = component "Adaptador BD Recomendación" "Guarda predicciones y recomendaciones generadas." "PostgreSQL Adapter" {
                    tags "Outbound Adapter"
                }
                recomendacionTrazabilidadClient = component "Cliente Trazabilidad" "Obtiene interacciones académicas del estudiante." "REST Client" {
                    tags "Outbound Adapter"
                }
                recomendacionCursosClient = component "Cliente Cursos y Recursos" "Obtiene recursos educativos candidatos." "REST Client" {
                    tags "Outbound Adapter"
                }
                recomendacionXaiClient = component "Cliente XAI" "Solicita explicación de la recomendación generada." "REST Client" {
                    tags "Outbound Adapter"
                }
                recomendacionStorageClient = component "Cliente S3" "Consulta recursos educativos almacenados." "S3 Client" {
                    tags "Outbound Adapter"
                }
                recomendacionEventPublisher = component "Publicador de Eventos" "Publica eventos de recomendación generada." "EventBridge Client" {
                    tags "Outbound Adapter"
                }
            }

            recomendacionDb = container "BD Recomendación" "Almacena recomendaciones y predicciones." "PostgreSQL / Amazon RDS" {
                tags "Database"
            }

            xaiService = container "Microservicio XAI" "Genera explicaciones sobre las recomendaciones." "Python / XAI / Hexagonal" {
                tags "AI Service"

                xaiRestController = component "Controlador REST" "Recibe solicitudes de explicación." "FastAPI Controller" {
                    tags "Inbound Adapter"
                }
                generarExplicacionUseCase = component "Caso de Uso: Generar Explicación" "Orquesta la generación de explicaciones XAI." "Application Service" {
                    tags "Application"
                }
                consultarExplicacionUseCase = component "Caso de Uso: Consultar Explicación" "Recupera explicaciones previamente generadas." "Application Service" {
                    tags "Application"
                }
                resultadoRecomendacionDomain = component "Entidad Resultado de Recomendación" "Representa recomendación, predicción y nivel de dominio." "Domain Model" {
                    tags "Domain"
                }
                pesosAtencionDomain = component "Entidad Pesos de Atención" "Representa la influencia de interacciones previas." "Domain Model" {
                    tags "Domain"
                }
                motorExplicabilidad = component "Motor de Explicabilidad" "Transforma pesos de atención en explicaciones comprensibles." "Domain Service" {
                    tags "Domain"
                }
                xaiRepository = component "Adaptador BD XAI" "Persiste explicaciones y pesos de atención." "PostgreSQL Adapter" {
                    tags "Outbound Adapter"
                }
                xaiEventPublisher = component "Publicador de Eventos" "Publica eventos de explicación generada." "EventBridge Client" {
                    tags "Outbound Adapter"
                }
            }

            xaiDb = container "BD XAI" "Almacena explicaciones y pesos de atención." "PostgreSQL / Amazon RDS" {
                tags "Database"
            }

            moodleService = container "Microservicio de Integración LMS" "Expone datos sincronizados desde Moodle." "FastAPI / Hexagonal" {
                tags "Microservice"

                moodleRestController = component "Controlador REST" "Recibe consultas de datos LMS sincronizados." "FastAPI Controller" {
                    tags "Inbound Adapter"
                }
                consultarCursosLmsUseCase = component "Caso de Uso: Consultar Cursos LMS" "Obtiene cursos sincronizados desde Moodle." "Application Service" {
                    tags "Application"
                }
                consultarActividadesLmsUseCase = component "Caso de Uso: Consultar Actividades LMS" "Obtiene actividades sincronizadas." "Application Service" {
                    tags "Application"
                }
                consultarCalificacionesLmsUseCase = component "Caso de Uso: Consultar Calificaciones LMS" "Obtiene calificaciones sincronizadas." "Application Service" {
                    tags "Application"
                }
                consultarInteraccionesLmsUseCase = component "Caso de Uso: Consultar Interacciones LMS" "Obtiene eventos académicos sincronizados." "Application Service" {
                    tags "Application"
                }
                cursoLmsDomain = component "Entidad Curso LMS" "Representa cursos importados desde Moodle." "Domain Model" {
                    tags "Domain"
                }
                actividadLmsDomain = component "Entidad Actividad LMS" "Representa actividades importadas desde Moodle." "Domain Model" {
                    tags "Domain"
                }
                calificacionLmsDomain = component "Entidad Calificación LMS" "Representa notas y resultados académicos." "Domain Model" {
                    tags "Domain"
                }
                interaccionLmsDomain = component "Entidad Interacción LMS" "Representa eventos de aprendizaje de Moodle." "Domain Model" {
                    tags "Domain"
                }
                moodleRepository = component "Adaptador BD Integración LMS" "Consulta datos sincronizados desde Moodle." "PostgreSQL Adapter" {
                    tags "Outbound Adapter"
                }
                moodleEventPublisher = component "Publicador de Eventos" "Publica eventos de datos LMS consultados." "EventBridge Client" {
                    tags "Outbound Adapter"
                }
            }

            moodleDb = container "BD Integración LMS" "Almacena datos sincronizados desde Moodle." "PostgreSQL / Amazon RDS" {
                tags "Database"
            }

            eventBus = container "Bus de Eventos" "Publica y enruta eventos del sistema." "Amazon EventBridge" {
                tags "Event Bus"
            }

            queue = container "Cola de Procesamiento" "Desacopla tareas asíncronas." "Amazon SQS" {
                tags "Queue"
            }

            lambdaMoodle = container "Lambda Sincronización Moodle" "Sincroniza datos académicos periódicamente." "AWS Lambda / Python" {
                tags "Lambda"
            }

            lambdaInteracciones = container "Lambda Procesamiento de Interacciones" "Limpia y transforma interacciones académicas." "AWS Lambda / Python" {
                tags "Lambda"
            }

            lambdaAlertas = container "Lambda Alertas Académicas" "Genera alertas de riesgo académico." "AWS Lambda / Python" {
                tags "Lambda"
            }

            lambdaRecursos = container "Lambda Procesamiento de Recursos" "Procesa metadatos de archivos subidos." "AWS Lambda / Python" {
                tags "Lambda"
            }

            storage = container "Almacenamiento de Recursos" "Guarda archivos y recursos educativos." "Amazon S3" {
                tags "Storage"
            }
        }

        estudiante -> sistema "Consulta progreso, recomendaciones y explicaciones." "HTTPS"
        docente -> sistema "Consulta dashboards, trazabilidad y alertas." "HTTPS"
        sistema -> moodle "Sincroniza datos académicos." "Moodle API / HTTPS"
        sistema -> aws "Se despliega y opera en la nube." "EC2, RDS, S3, Lambda, EventBridge, SQS"

        estudiante -> sistema.frontend "Consulta progreso, recomendaciones y explicaciones." "HTTPS"
        docente -> sistema.frontend "Consulta dashboards, trazabilidad y alertas." "HTTPS"
        sistema.frontend -> sistema.apiGateway "Consume servicios del backend." "REST / HTTPS"

        sistema.apiGateway -> sistema.usuariosService "Valida usuarios y permisos." "REST / HTTPS"
        sistema.apiGateway -> sistema.cursosService "Consulta cursos y recursos." "REST / HTTPS"
        sistema.apiGateway -> sistema.trazabilidadService "Consulta progreso e interacciones." "REST / HTTPS"
        sistema.apiGateway -> sistema.recomendacionService "Solicita recomendaciones." "REST / HTTPS"
        sistema.apiGateway -> sistema.xaiService "Solicita explicaciones." "REST / HTTPS"
        sistema.apiGateway -> sistema.moodleService "Consulta datos LMS sincronizados." "REST / HTTPS"

        sistema.recomendacionService -> sistema.trazabilidadService "Obtiene interacciones académicas." "REST / HTTPS"
        sistema.recomendacionService -> sistema.cursosService "Obtiene recursos candidatos." "REST / HTTPS"
        sistema.recomendacionService -> sistema.xaiService "Solicita explicación de resultados." "REST / HTTPS"
        sistema.trazabilidadService -> sistema.moodleService "Solicita datos académicos sincronizados." "REST / HTTPS"
        sistema.cursosService -> sistema.moodleService "Consulta cursos y actividades LMS." "REST / HTTPS"

        sistema.usuariosService -> sistema.usuariosDb "Lee y escribe usuarios y roles." "SQL / TLS"
        sistema.cursosService -> sistema.cursosDb "Lee y escribe cursos y recursos." "SQL / TLS"
        sistema.trazabilidadService -> sistema.trazabilidadDb "Lee y escribe progreso e interacciones." "SQL / TLS"
        sistema.recomendacionService -> sistema.recomendacionDb "Lee y escribe recomendaciones." "SQL / TLS"
        sistema.xaiService -> sistema.xaiDb "Lee y escribe explicaciones." "SQL / TLS"
        sistema.moodleService -> sistema.moodleDb "Lee y escribe datos sincronizados." "SQL / TLS"

        sistema.cursosService -> sistema.storage "Gestiona recursos educativos." "S3 API / HTTPS"
        sistema.recomendacionService -> sistema.storage "Consulta recursos recomendables." "S3 API / HTTPS"

        sistema.lambdaMoodle -> moodle "Extrae cursos, actividades, calificaciones e interacciones." "Moodle API / HTTPS"
        sistema.lambdaMoodle -> sistema.moodleDb "Actualiza datos sincronizados." "SQL / TLS"
        sistema.lambdaMoodle -> sistema.eventBus "Publica sincronización LMS completada." "EventBridge"

        sistema.trazabilidadService -> sistema.eventBus "Publica eventos de interacción académica." "EventBridge"
        sistema.eventBus -> sistema.queue "Enruta eventos para procesamiento." "EventBridge Rule"
        sistema.queue -> sistema.lambdaInteracciones "Entrega eventos de interacción." "SQS Trigger"
        sistema.lambdaInteracciones -> sistema.trazabilidadDb "Actualiza interacciones procesadas." "SQL / TLS"

        sistema.recomendacionService -> sistema.eventBus "Publica eventos de recomendación generada." "EventBridge"
        sistema.eventBus -> sistema.lambdaAlertas "Activa evaluación de riesgo académico." "EventBridge Rule"
        sistema.lambdaAlertas -> sistema.trazabilidadDb "Consulta progreso académico." "SQL / TLS"
        sistema.lambdaAlertas -> sistema.xaiDb "Registra alertas explicables." "SQL / TLS"

        sistema.storage -> sistema.lambdaRecursos "Activa procesamiento de archivos subidos." "S3 Event"
        sistema.lambdaRecursos -> sistema.cursosDb "Actualiza metadatos de recursos." "SQL / TLS"

        sistema.apiGateway -> sistema.usuariosService.usuariosRestController "Valida acceso y gestiona usuarios." "REST / HTTPS"
        sistema.usuariosService.usuariosRestController -> sistema.usuariosService.autenticarUsuarioUseCase "Ejecuta autenticación."
        sistema.usuariosService.usuariosRestController -> sistema.usuariosService.gestionarUsuarioUseCase "Ejecuta gestión de usuarios."
        sistema.usuariosService.usuariosRestController -> sistema.usuariosService.gestionarRolUseCase "Ejecuta gestión de roles."
        sistema.usuariosService.autenticarUsuarioUseCase -> sistema.usuariosService.authService "Valida credenciales."
        sistema.usuariosService.autenticarUsuarioUseCase -> sistema.usuariosService.tokenProvider "Genera token."
        sistema.usuariosService.gestionarUsuarioUseCase -> sistema.usuariosService.usuarioDomain "Valida usuario."
        sistema.usuariosService.gestionarRolUseCase -> sistema.usuariosService.rolDomain "Valida rol."
        sistema.usuariosService.gestionarRolUseCase -> sistema.usuariosService.permisoDomain "Valida permisos."
        sistema.usuariosService.autenticarUsuarioUseCase -> sistema.usuariosService.usuariosRepository "Consulta usuario."
        sistema.usuariosService.gestionarUsuarioUseCase -> sistema.usuariosService.usuariosRepository "Guarda o consulta usuarios."
        sistema.usuariosService.gestionarRolUseCase -> sistema.usuariosService.usuariosRepository "Guarda o consulta roles."
        sistema.usuariosService.gestionarUsuarioUseCase -> sistema.usuariosService.usuariosEventPublisher "Publica usuario actualizado."
        sistema.usuariosService.autenticarUsuarioUseCase -> sistema.usuariosService.usuariosEventPublisher "Publica usuario autenticado."
        sistema.usuariosService.usuariosRepository -> sistema.usuariosDb "Lee y escribe usuarios, roles y permisos." "SQL / TLS"
        sistema.usuariosService.usuariosEventPublisher -> sistema.eventBus "Publica evento de usuario." "EventBridge"

        sistema.apiGateway -> sistema.cursosService.cursosRestController "Consulta cursos, actividades y recursos." "REST / HTTPS"
        sistema.recomendacionService -> sistema.cursosService.cursosRestController "Solicita recursos candidatos." "REST / HTTPS"
        sistema.cursosService.cursosRestController -> sistema.cursosService.gestionarCursoUseCase "Ejecuta gestión de cursos."
        sistema.cursosService.cursosRestController -> sistema.cursosService.gestionarActividadUseCase "Ejecuta gestión de actividades."
        sistema.cursosService.cursosRestController -> sistema.cursosService.gestionarRecursoUseCase "Ejecuta gestión de recursos."
        sistema.cursosService.cursosRestController -> sistema.cursosService.buscarRecursosUseCase "Ejecuta búsqueda de recursos candidatos."
        sistema.cursosService.gestionarCursoUseCase -> sistema.cursosService.cursoDomain "Valida curso."
        sistema.cursosService.gestionarActividadUseCase -> sistema.cursosService.actividadDomain "Valida actividad."
        sistema.cursosService.gestionarRecursoUseCase -> sistema.cursosService.recursoDomain "Valida recurso."
        sistema.cursosService.buscarRecursosUseCase -> sistema.cursosService.recursoDomain "Filtra recursos recomendables."
        sistema.cursosService.gestionarCursoUseCase -> sistema.cursosService.cursosRepository "Guarda o consulta cursos."
        sistema.cursosService.gestionarActividadUseCase -> sistema.cursosService.cursosRepository "Guarda o consulta actividades."
        sistema.cursosService.gestionarRecursoUseCase -> sistema.cursosService.cursosRepository "Guarda metadatos de recursos."
        sistema.cursosService.buscarRecursosUseCase -> sistema.cursosService.cursosRepository "Consulta recursos candidatos."
        sistema.cursosService.gestionarRecursoUseCase -> sistema.cursosService.cursosStorageClient "Guarda archivos educativos."
        sistema.cursosService.buscarRecursosUseCase -> sistema.cursosService.cursosStorageClient "Consulta archivos de recursos."
        sistema.cursosService.gestionarCursoUseCase -> sistema.cursosService.cursosMoodleClient "Consulta cursos sincronizados."
        sistema.cursosService.gestionarActividadUseCase -> sistema.cursosService.cursosMoodleClient "Consulta actividades sincronizadas."
        sistema.cursosService.gestionarRecursoUseCase -> sistema.cursosService.cursosEventPublisher "Publica recurso actualizado."
        sistema.cursosService.cursosRepository -> sistema.cursosDb "Lee y escribe cursos, actividades y recursos." "SQL / TLS"
        sistema.cursosService.cursosStorageClient -> sistema.storage "Lee y escribe archivos educativos." "S3 API / HTTPS"
        sistema.cursosService.cursosMoodleClient -> sistema.moodleService "Obtiene datos académicos." "REST / HTTPS"
        sistema.cursosService.cursosEventPublisher -> sistema.eventBus "Publica evento de recurso actualizado." "EventBridge"

        sistema.apiGateway -> sistema.trazabilidadService.trazabilidadRestController "Consulta progreso y registra interacciones." "REST / HTTPS"
        sistema.recomendacionService -> sistema.trazabilidadService.trazabilidadRestController "Obtiene interacciones para inferencia." "REST / HTTPS"
        sistema.trazabilidadService.trazabilidadRestController -> sistema.trazabilidadService.registrarInteraccionUseCase "Ejecuta registro de interacción."
        sistema.trazabilidadService.trazabilidadRestController -> sistema.trazabilidadService.consultarProgresoUseCase "Ejecuta consulta de progreso."
        sistema.trazabilidadService.trazabilidadRestController -> sistema.trazabilidadService.calcularIndicadoresUseCase "Ejecuta cálculo de indicadores."
        sistema.trazabilidadService.registrarInteraccionUseCase -> sistema.trazabilidadService.interaccionDomain "Valida interacción académica."
        sistema.trazabilidadService.consultarProgresoUseCase -> sistema.trazabilidadService.progresoDomain "Construye progreso académico."
        sistema.trazabilidadService.calcularIndicadoresUseCase -> sistema.trazabilidadService.progresoDomain "Calcula indicadores de desempeño."
        sistema.trazabilidadService.registrarInteraccionUseCase -> sistema.trazabilidadService.trazabilidadRepository "Guarda interacción."
        sistema.trazabilidadService.consultarProgresoUseCase -> sistema.trazabilidadService.trazabilidadRepository "Consulta progreso."
        sistema.trazabilidadService.calcularIndicadoresUseCase -> sistema.trazabilidadService.trazabilidadRepository "Consulta datos históricos."
        sistema.trazabilidadService.consultarProgresoUseCase -> sistema.trazabilidadService.trazabilidadMoodleClient "Consulta datos LMS sincronizados."
        sistema.trazabilidadService.registrarInteraccionUseCase -> sistema.trazabilidadService.trazabilidadEventPublisher "Publica interacción registrada."
        sistema.trazabilidadService.trazabilidadRepository -> sistema.trazabilidadDb "Lee y escribe trazabilidad." "SQL / TLS"
        sistema.trazabilidadService.trazabilidadMoodleClient -> sistema.moodleService "Obtiene datos académicos." "REST / HTTPS"
        sistema.trazabilidadService.trazabilidadEventPublisher -> sistema.eventBus "Publica evento de interacción académica." "EventBridge"

        sistema.apiGateway -> sistema.recomendacionService.recomendacionRestController "Solicita recomendaciones." "REST / HTTPS"
        sistema.recomendacionService.recomendacionRestController -> sistema.recomendacionService.generarRecomendacionUseCase "Ejecuta generación de recomendación."
        sistema.recomendacionService.generarRecomendacionUseCase -> sistema.recomendacionService.recomendacionTrazabilidadClient "Solicita interacciones académicas."
        sistema.recomendacionService.generarRecomendacionUseCase -> sistema.recomendacionService.recomendacionCursosClient "Solicita recursos candidatos."
        sistema.recomendacionService.generarRecomendacionUseCase -> sistema.recomendacionService.obtenerEstadoConocimientoUseCase "Solicita estado de conocimiento."
        sistema.recomendacionService.obtenerEstadoConocimientoUseCase -> sistema.recomendacionService.saktModel "Ejecuta inferencia SAKT."
        sistema.recomendacionService.generarRecomendacionUseCase -> sistema.recomendacionService.motorRecomendacion "Genera ranking de recursos."
        sistema.recomendacionService.motorRecomendacion -> sistema.recomendacionService.recomendacionStorageClient "Consulta archivos de recursos."
        sistema.recomendacionService.generarRecomendacionUseCase -> sistema.recomendacionService.recomendacionXaiClient "Solicita explicación."
        sistema.recomendacionService.generarRecomendacionUseCase -> sistema.recomendacionService.recomendacionRepository "Guarda recomendación."
        sistema.recomendacionService.generarRecomendacionUseCase -> sistema.recomendacionService.recomendacionEventPublisher "Publica evento."
        sistema.recomendacionService.recomendacionTrazabilidadClient -> sistema.trazabilidadService "Obtiene progreso e interacciones." "REST / HTTPS"
        sistema.recomendacionService.recomendacionCursosClient -> sistema.cursosService "Obtiene cursos y recursos." "REST / HTTPS"
        sistema.recomendacionService.recomendacionXaiClient -> sistema.xaiService "Solicita explicación XAI." "REST / HTTPS"
        sistema.recomendacionService.recomendacionRepository -> sistema.recomendacionDb "Lee y escribe recomendaciones." "SQL / TLS"
        sistema.recomendacionService.recomendacionStorageClient -> sistema.storage "Consulta recursos educativos." "S3 API / HTTPS"
        sistema.recomendacionService.recomendacionEventPublisher -> sistema.eventBus "Publica recomendación generada." "EventBridge"

        sistema.apiGateway -> sistema.xaiService.xaiRestController "Consulta explicaciones." "REST / HTTPS"
        sistema.recomendacionService -> sistema.xaiService.xaiRestController "Solicita explicación de recomendación." "REST / HTTPS"
        sistema.xaiService.xaiRestController -> sistema.xaiService.generarExplicacionUseCase "Ejecuta generación de explicación."
        sistema.xaiService.xaiRestController -> sistema.xaiService.consultarExplicacionUseCase "Ejecuta consulta de explicación."
        sistema.xaiService.generarExplicacionUseCase -> sistema.xaiService.resultadoRecomendacionDomain "Procesa resultado de recomendación."
        sistema.xaiService.generarExplicacionUseCase -> sistema.xaiService.pesosAtencionDomain "Procesa pesos de atención."
        sistema.xaiService.generarExplicacionUseCase -> sistema.xaiService.motorExplicabilidad "Genera explicación interpretable."
        sistema.xaiService.consultarExplicacionUseCase -> sistema.xaiService.xaiRepository "Consulta explicación almacenada."
        sistema.xaiService.generarExplicacionUseCase -> sistema.xaiService.xaiRepository "Guarda explicación generada."
        sistema.xaiService.generarExplicacionUseCase -> sistema.xaiService.xaiEventPublisher "Publica explicación generada."
        sistema.xaiService.xaiRepository -> sistema.xaiDb "Lee y escribe explicaciones." "SQL / TLS"
        sistema.xaiService.xaiEventPublisher -> sistema.eventBus "Publica evento de explicación generada." "EventBridge"

        sistema.apiGateway -> sistema.moodleService.moodleRestController "Consulta datos LMS sincronizados." "REST / HTTPS"
        sistema.cursosService -> sistema.moodleService.moodleRestController "Consulta cursos y actividades LMS." "REST / HTTPS"
        sistema.trazabilidadService -> sistema.moodleService.moodleRestController "Consulta calificaciones e interacciones LMS." "REST / HTTPS"
        sistema.moodleService.moodleRestController -> sistema.moodleService.consultarCursosLmsUseCase "Ejecuta consulta de cursos."
        sistema.moodleService.moodleRestController -> sistema.moodleService.consultarActividadesLmsUseCase "Ejecuta consulta de actividades."
        sistema.moodleService.moodleRestController -> sistema.moodleService.consultarCalificacionesLmsUseCase "Ejecuta consulta de calificaciones."
        sistema.moodleService.moodleRestController -> sistema.moodleService.consultarInteraccionesLmsUseCase "Ejecuta consulta de interacciones."
        sistema.moodleService.consultarCursosLmsUseCase -> sistema.moodleService.cursoLmsDomain "Construye curso LMS."
        sistema.moodleService.consultarActividadesLmsUseCase -> sistema.moodleService.actividadLmsDomain "Construye actividad LMS."
        sistema.moodleService.consultarCalificacionesLmsUseCase -> sistema.moodleService.calificacionLmsDomain "Construye calificación LMS."
        sistema.moodleService.consultarInteraccionesLmsUseCase -> sistema.moodleService.interaccionLmsDomain "Construye interacción LMS."
        sistema.moodleService.consultarCursosLmsUseCase -> sistema.moodleService.moodleRepository "Consulta cursos sincronizados."
        sistema.moodleService.consultarActividadesLmsUseCase -> sistema.moodleService.moodleRepository "Consulta actividades sincronizadas."
        sistema.moodleService.consultarCalificacionesLmsUseCase -> sistema.moodleService.moodleRepository "Consulta calificaciones sincronizadas."
        sistema.moodleService.consultarInteraccionesLmsUseCase -> sistema.moodleService.moodleRepository "Consulta interacciones sincronizadas."
        sistema.moodleService.consultarInteraccionesLmsUseCase -> sistema.moodleService.moodleEventPublisher "Publica consulta de interacciones."
        sistema.moodleService.moodleRepository -> sistema.moodleDb "Lee datos sincronizados." "SQL / TLS"
        sistema.moodleService.moodleEventPublisher -> sistema.eventBus "Publica evento LMS consultado." "EventBridge"
    }

    views {
        systemContext sistema "contexto-sistema-recomendacion" {
            title "Diagrama de Contexto - Sistema Web de Recomendación Adaptativa"
            description "Vista de contexto del sistema, usuarios y dependencias externas."
            include *
            autoLayout lr
        }

        container sistema "contenedores-sistema-recomendacion" {
            title "Diagrama de Contenedores - Sistema Web de Recomendación Adaptativa"
            description "Vista de contenedores con microservicios, bases de datos independientes y procesamiento asíncrono en AWS."
            include *
            autoLayout lr
        }

        component sistema.usuariosService "componentes-microservicio-usuarios" {
            title "Diagrama de Componentes - Microservicio de Usuarios"
            description "Vista interna del microservicio de usuarios usando arquitectura hexagonal."
            include *
            autoLayout lr
        }

        component sistema.recomendacionService "componentes-microservicio-recomendacion" {
            title "Diagrama de Componentes - Microservicio de Recomendación"
            description "Vista interna del microservicio de recomendación usando arquitectura hexagonal."
            include *
            autoLayout lr
        }

        component sistema.trazabilidadService "componentes-microservicio-trazabilidad" {
            title "Diagrama de Componentes - Microservicio de Trazabilidad"
            description "Vista interna del microservicio de trazabilidad usando arquitectura hexagonal."
            include *
            autoLayout lr
        }

        component sistema.xaiService "componentes-microservicio-xai" {
            title "Diagrama de Componentes - Microservicio XAI"
            description "Vista interna del microservicio XAI usando arquitectura hexagonal."
            include *
            autoLayout lr
        }

        component sistema.cursosService "componentes-microservicio-cursos-recursos" {
            title "Diagrama de Componentes - Microservicio de Cursos y Recursos"
            description "Vista interna del microservicio de cursos y recursos usando arquitectura hexagonal."
            include *
            autoLayout lr
        }

        component sistema.moodleService "componentes-microservicio-integracion-lms" {
            title "Diagrama de Componentes - Microservicio de Integración LMS"
            description "Vista interna del microservicio de integración LMS usando arquitectura hexagonal."
            include *
            autoLayout lr
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

            element "Gateway" {
                background "#0D47A1"
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

            element "Queue" {
                shape Pipe
                background "#795548"
                color "#FFFFFF"
            }

            element "Lambda" {
                shape Hexagon
                background "#FF9900"
                color "#000000"
            }

            element "Inbound Adapter" {
                background "#2E7D32"
                color "#FFFFFF"
            }

            element "Application" {
                background "#1565C0"
                color "#FFFFFF"
            }

            element "Domain" {
                background "#6A1B9A"
                color "#FFFFFF"
            }

            element "Outbound Adapter" {
                background "#EF6C00"
                color "#FFFFFF"
            }

            relationship "Relationship" {
                color "#707070"
                thickness 2
            }
        }
    }
}
