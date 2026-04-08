# optimizador-karate-test

Suite de pruebas de API automatizadas con [Karate DSL](https://github.com/karatelabs/karate) para el proyecto **Optimizador de Envíos**, compuesto por dos microservicios:

- `user-service` — registro y autenticación (`http://localhost:8081`)
- `shipment-service` — cotización, confirmación e historial de pedidos (`http://localhost:8080`)

> Las pruebas fueron generadas mediante una implementación de **ASDD** (Automated Scenario-Driven Development) optimizada para Karate por [Nahuel Lemes](https://github.com/nahulemesf). El flujo completo — desde la spec de automatización hasta los features, data files y schemas — fue producido a través de ese proceso.

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

## Reporte de bugs

Durante la ejecución del suite se encontraron discrepancias entre lo que el PRD define y lo que el backend implementa.

→ [Ver reporte completo](docs/BUG_REPORT.md)

---

## Baseline del template

Este template queda aterrizado a estas decisiones:

- **Build tool:** Maven
- **Java:** 17
- **Karate:** 1.5.2
- **Tipo de automatización:** API-first
- **Organización:** por dominio funcional
- **Runners:** uno por dominio
- **Tags:** `@smoke`, `@regression`, `@negative`, `@auth`, `@contract`, `@wip`
- **Ambiente por defecto:** `qa`
- **Ambientes adicionales:** opcionales, solo si el proyecto o el requerimiento los piden explícitamente
- **Auth configurable:** `bearer`, `oauth`, `login`

## Scaffold pre-built

El scaffold Karate ya está incluido en el template. Al implementar un feature, solo se agregan los artefactos del dominio:

- `src/test/java/template/<dominio>/<Dominio>Runner.java`
- `src/test/java/template/<dominio>/<flujo>.feature`
- `src/test/resources/data/<dominio>/**`
- `src/test/resources/schemas/<dominio>/**`

Y, además:

- specs en `.github/specs/`

## Flujo

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
