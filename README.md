# Optimizador de Envíos - Suite de Pruebas Karate DSL

Suite de pruebas de API automatizadas con [Karate DSL](https://github.com/karatelabs/karate) para el proyecto **Optimizador de Envíos**, compuesto por dos microservicios:

- `user-service` — registro y autenticación (`http://localhost:8081`)
- `shipment-service` — cotización, confirmación e historial de pedidos (`http://localhost:8080`)

> Las pruebas fueron generadas mediante una implementación de **ASDD** (Agent Spec-Driven Development) optimizada para Karate por [Nahuel Lemes](https://github.com/nahulemesf).  
> El flujo completo — desde la spec de automatización hasta los features, data files y schemas — fue producido a través de ese proceso.

---

## Estructura del proyecto

```text
src/test/java/
  karate-config.js                    # URLs, paths y tokens por ambiente
  optimizadorenvios/
    AllRunner.java                    # Runner principal (excluye @wip)
    usuarios/
      UsuariosRunner.java
      registro.feature
      login.feature
    pedidos/
      PedidosRunner.java
      registro-pedido.feature
      recomendacion-proveedor.feature
      confirmacion-persistencia.feature
    rutas/
      RutasRunner.java
      transformacion-coordenadas.feature
      ors-error.feature

src/test/resources/
  helpers/auth/register-login.feature # Helper reutilizable de autenticación
  data/<dominio>/                     # Datos de entrada por escenario
  schemas/<dominio>/                  # Schemas de validación de respuesta
```

---

## Reporte de bugs

Durante la ejecución del suite se encontraron discrepancias entre lo que el PRD define y lo que el backend implementa.

→ [Ver reporte completo](docs/BUG_REPORT.md)

---

## Cómo ejecutar las pruebas

### Requisitos previos

- Java 17+
- `user-service` corriendo en `http://localhost:8081`
- `shipment-service` corriendo en `http://localhost:8080`

### Ejecutar el suite completo

```bash
./mvnw test
```

Esto ejecuta `AllRunner`, que cubre los 3 dominios en un solo reporte y excluye automáticamente los escenarios marcados con `@wip`.

### Ejecutar un dominio individual (desde el IDE)

Cada dominio tiene su propio runner para ejecución local:

| Dominio | Runner |
|---|---|
| Usuarios | `UsuariosRunner.java` |
| Pedidos | `PedidosRunner.java` |
| Rutas | `RutasRunner.java` |

### Ver el reporte HTML

Después de ejecutar, el reporte unificado queda en:

```
target/karate-reports/karate-summary.html
```

---

## Estado del suite

| Dominio | Features | Escenarios | Pasados | `@wip` |
|---|---|---|---|---|
| usuarios | 2 | 6 | 6 | 0 |
| pedidos | 3 | 13 | 13 | 4 |
| rutas | 2 | 0 | 0 | 2 |
| **Total** | **7** | **19** | **19** | **6** |

Los escenarios `@wip` están bloqueados por implementación pendiente en el backend (ver reporte de bugs).

---

## Implementación de ASDD para Karate

El proceso de desarrollo de esta suite se basó en una implementación personalizada de **ASDD** (Agent Spec-Driven Development) para Karate, que optimiza la generación de artefactos a partir de requerimientos escritos en lenguaje natural.

## Flujo

### Paso 1 — Escribir el requerimiento en lenguaje natural
El proceso inicia con la redacción de un requerimiento o historia de usuario en lenguaje natural, siguiendo una plantilla estructurada que incluye:
- Descripción general del feature o funcionalidad a automatizar
- Detalles del dominio, subdominios y endpoints involucrados
- Estrategia de autenticación y flujo de obtención de tokens
- Lista de artefactos a generar (runners, features, helpers, data files, schemas)

### Paso 2 — Implementación asistida por agentes
Con el requerimiento definido, se utilizan comandos específicos para que un agente especializado en ASDD genere automáticamente los artefactos necesarios para la automatización en Karate. Las opciones incluyen:

### Opción A — Orquestación completa

```text
/asdd-orchestrate nombre-feature
```

### Opción B — Paso a paso

```text
/generate-spec nombre-feature
```

Apruebas la spec:

```yaml
status: APPROVED
```

Luego:

```text
/implement-karate nombre-feature
```

> Sin `status: APPROVED` no se crea ni modifica automatización Karate.

## Convenciones del proyecto generado

```text
.
├── pom.xml
├── mvnw
├── mvnw.cmd
├── .mvn/
│   └── wrapper/
├── src/
│   └── test/
│       ├── java/
│       │   ├── karate-config.js
│       │   ├── logback-test.xml
│       │   └── template/
│       │       └── <dominio>/
│       │           ├── <Dominio>Runner.java
│       │           └── <flujo>.feature
│       └── resources/
│           ├── data/
│           │   └── <dominio>/
│           ├── helpers/
│           │   ├── auth/
│           │   └── common.js
│           └── schemas/
│               └── <dominio>/
└── .github/
```

## Ejecución esperada

```text
./mvnw test
./mvnw test -Dkarate.env=qa
./mvnw test -Dkarate.options="--tags @smoke"
```

## Documentación clave

- `.github/README.md`
- `.github/AGENTS.md`
- `.github/copilot-instructions.md`
- `.github/instructions/karate.instructions.md`
- `.github/specs/README.md`

## Nota sobre la versión de Karate

El template queda pinneado en **Karate 1.5.2**. Según las notas oficiales de **v1.5.0**, desde esa serie Karate requiere **Java 17** y el Maven `group-id` cambió de `com.intuit.karate` a `io.karatelabs`, mientras los imports Java siguen en `com.intuit.karate.*` en la serie `1.5.x`. Fuente oficial:

- https://github.com/karatelabs/karate/releases
