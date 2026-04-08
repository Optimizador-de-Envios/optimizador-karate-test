# Optimizador de Envíos - Suite de Pruebas Karate DSL

Suite de pruebas de API automatizadas con [Karate DSL](https://github.com/karatelabs/karate) para el proyecto **Optimizador de Envíos**, compuesto por dos microservicios:

- `user-service` — registro y autenticación (`http://localhost:8081`)
- `shipment-service` — cotización, confirmación e historial de pedidos (`http://localhost:8080`)

---

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

## Cobertura de casos de prueba

Referencia cruzada entre los casos definidos en [`TEST_CASES.md`](../project_docs/TEST_CASES.md) y los escenarios Karate implementados.

| TC | Descripción breve | Feature | Tags | Estado |
|---|---|---|---|---|
| TC-HU07-02 | Correo duplicado retorna HTTP 409 | `usuarios/registro.feature` | `@negative` | ✅ Ejecutado |
| TC-HU07-03 | Campos obligatorios vacíos retorna HTTP 400 | `usuarios/registro.feature` | `@negative` | ✅ Ejecutado |
| TC-HU07-04 | Contraseña < 8 caracteres retorna HTTP 400 | `usuarios/registro.feature` | `@negative` | ✅ Ejecutado |
| TC-HU07-05 | Contraseña almacenada cifrada (login lo verifica) | `usuarios/registro.feature` | `@smoke` | ✅ Ejecutado |
| TC-HU08-02 | Credenciales inválidas retorna HTTP 401 | `usuarios/login.feature` | `@negative` | ✅ Ejecutado |
| TC-HU08-01 | Login exitoso retorna token JWT | `usuarios/login.feature` | `@smoke @auth` | ✅ Ejecutado |
| TC-HU01-03 | Origen, destino y peso vacíos retorna HTTP 400 | `pedidos/registro-pedido.feature` | `@negative` | ✅ Ejecutado |
| TC-HU01-04 | Origen fuera de Colombia retorna HTTP 400 | `pedidos/registro-pedido.feature` | `@negative @wip` | ⚠️ `@wip` |
| TC-HU01-04 | Destino fuera de Colombia retorna HTTP 400 | `pedidos/registro-pedido.feature` | `@negative @wip` | ⚠️ `@wip` |
| TC-HU01-05 | Peso mínimo (0.001 Kg) aceptado — HTTP 200 | `pedidos/registro-pedido.feature` | `@smoke` | ✅ Ejecutado |
| TC-HU01-06 | Peso máximo (70 Kg) aceptado — HTTP 200 | `pedidos/registro-pedido.feature` | `@smoke` | ✅ Ejecutado |
| TC-HU01-07 | Peso inferior al mínimo (0.0009 Kg) retorna HTTP 400 | `pedidos/registro-pedido.feature` | `@negative` | ✅ Ejecutado |
| TC-HU01-08 | Peso superior al máximo (70.001 Kg) retorna HTTP 400 | `pedidos/registro-pedido.feature` | `@negative` | ✅ Ejecutado |
| TC-HU02-02 | Sin prioridad retorna HTTP 400 | `pedidos/registro-pedido.feature` | `@negative` | ✅ Ejecutado |
| TC-HU03-01 | Prioridad COST → recomienda proveedor de menor costo | `pedidos/recomendacion-proveedor.feature` | `@smoke` | ✅ Ejecutado |
| TC-HU03-02 | Prioridad TIME → recomienda proveedor de menor tiempo | `pedidos/recomendacion-proveedor.feature` | `@smoke` | ✅ Ejecutado |
| TC-HU03-03 | Desempate por tiempo ante empate en costo | `pedidos/recomendacion-proveedor.feature` | `@regression @wip` | ⚠️ `@wip` |
| TC-HU03-04 | Desempate por costo ante empate en tiempo | `pedidos/recomendacion-proveedor.feature` | `@regression @wip` | ⚠️ `@wip` |
| TC-HU03-05 | Contrato de respuesta incluye campos requeridos | `pedidos/recomendacion-proveedor.feature` | `@contract` | ✅ Ejecutado |
| TC-HU04-03 | Recomendación principal no aparece en alternativas | `pedidos/recomendacion-proveedor.feature` | `@contract` | ✅ Ejecutado |
| TC-HU05-02 | Confirmación sin proveedor retorna HTTP 400 | `pedidos/confirmacion-persistencia.feature` | `@negative` | ✅ Ejecutado |
| TC-HU05-03 | Proveedor inválido en confirmación retorna HTTP 400/422 | `pedidos/confirmacion-persistencia.feature` | `@negative` | ✅ Ejecutado |
| TC-HU05-04 | Confirmación exitosa persiste pedido en mis-pedidos | `pedidos/confirmacion-persistencia.feature` | `@smoke @auth` | ✅ Ejecutado |
| TC-HU06-03 | Coordenadas ORS `[lng,lat]` convertidas a `[lat,lng]` | `rutas/transformacion-coordenadas.feature` | `@regression @contract @wip` | ⚠️ `@wip` |
| TC-HU06-05 | ORS falla — backend responde de forma controlada | `rutas/ors-error.feature` | `@regression @negative @wip` | ⚠️ `@wip` |

> Los TCs marcados con ⚠️ `@wip` están bloqueados por implementación pendiente en el backend. Ver [reporte de bugs](docs/BUG_REPORT.md).

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

