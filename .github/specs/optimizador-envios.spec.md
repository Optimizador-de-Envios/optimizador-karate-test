# Spec: optimizador-envios

**Status:** APPROVED
**Feature:** optimizador-envios
**Ambiente:** qa

---

## Dominio

`optimizador-envios` (multi-subdominio)

| Subdominio | Paquete Java | Base URL | Puerto |
|---|---|---|---|
| `usuarios` | `template.usuarios` | `http://localhost:8081` | 8081 |
| `pedidos` | `template.pedidos` | `http://localhost:8080` | 8080 |
| `rutas` | `template.rutas` | `http://localhost:8080` | 8080 |

---

## Auth

- Estrategia: `login`
- Helper: `src/test/resources/helpers/auth/register-login.feature`
- Flujo:
  1. `POST /api/users/register` — crea usuario de prueba con email único (timestamp)
  2. `POST /api/users/login` — obtiene JWT
  3. `callonce` — token reutilizado por todos los escenarios autenticados del dominio
- Token usado como: `Authorization: Bearer {{ token }}`
- El usuario semilla NO existe: se crea en tiempo de ejecución

---

## Artefactos a crear

### Runners

| Archivo | Package | Dominio |
|---|---|---|
| `src/test/java/template/usuarios/UsuariosRunner.java` | `template.usuarios` | usuarios |
| `src/test/java/template/pedidos/PedidosRunner.java` | `template.pedidos` | pedidos |
| `src/test/java/template/rutas/RutasRunner.java` | `template.rutas` | rutas |

### Features

| Archivo | Subdominio |
|---|---|
| `src/test/java/template/usuarios/registro.feature` | usuarios |
| `src/test/java/template/usuarios/login.feature` | usuarios |
| `src/test/java/template/pedidos/registro-pedido.feature` | pedidos |
| `src/test/java/template/pedidos/recomendacion-proveedor.feature` | pedidos |
| `src/test/java/template/pedidos/confirmacion-persistencia.feature` | pedidos |
| `src/test/java/template/rutas/transformacion-coordenadas.feature` | rutas |
| `src/test/java/template/rutas/ors-error.feature` | rutas |

### Helpers

| Archivo | Propósito |
|---|---|
| `src/test/resources/helpers/auth/register-login.feature` | Registro + login → JWT via callonce |

### Data

| Archivo | Usado en |
|---|---|
| `src/test/resources/data/usuarios/registro.json` | registro.feature |
| `src/test/resources/data/usuarios/login.json` | login.feature |
| `src/test/resources/data/pedidos/pedido-base.json` | registro-pedido, recomendacion, confirmacion |
| `src/test/resources/data/pedidos/pedidos-invalidos.json` | registro-pedido (negativos) |
| `src/test/resources/data/pedidos/recomendacion-casos.json` | recomendacion-proveedor |
| `src/test/resources/data/rutas/coordenadas-ors.json` | transformacion-coordenadas |
| `src/test/resources/data/rutas/ors-error-stub.json` | ors-error |

### Schemas

| Archivo | Valida |
|---|---|
| `src/test/resources/schemas/usuarios/registro-response.json` | POST /api/users/register — 201 |
| `src/test/resources/schemas/usuarios/login-response.json` | POST /api/users/login — 200, campo `token` |
| `src/test/resources/schemas/pedidos/recomendacion.json` | POST /api/v1/pedido — 201 happy path |
| `src/test/resources/schemas/pedidos/confirmar-response.json` | POST /api/v1/pedido/confirmar — 200 |

---

## Escenarios por subdominio

### Subdominio: `usuarios`

#### `registro.feature`

Tags: `@smoke @regression @negative`

| # | Tag | Descripción | Endpoint | Input clave | Expected |
|---|---|---|---|---|---|
| 1 | `@negative` | Correo duplicado | POST /api/users/register | email ya registrado | HTTP 409 |
| 2 | `@negative` | Campos obligatorios vacíos | POST /api/users/register | sin nombre/correo/password | HTTP 400 |
| 3 | `@negative` | Contraseña < 8 caracteres | POST /api/users/register | password corta | HTTP 400 |
| 4 | `@smoke` | Registro exitoso + login confirma hash | POST /api/users/register → POST /api/users/login | usuario con timestamp | HTTP 201 → HTTP 200 con token |

#### `login.feature`

Tags: `@smoke @regression @negative @auth`

| # | Tag | Descripción | Endpoint | Input clave | Expected |
|---|---|---|---|---|---|
| 1 | `@negative` | Credenciales inválidas | POST /api/users/login | email/password incorrectos | HTTP 401 |
| 2 | `@smoke @auth` | Login happy path | POST /api/users/login | credenciales válidas | HTTP 200, campo `token` presente |

---

### Subdominio: `pedidos`

#### `registro-pedido.feature`

Tags: `@regression @negative @smoke`

| # | Tag | Descripción | Endpoint | Input clave | Expected |
|---|---|---|---|---|---|
| 1 | `@negative` | Origen, destino y peso vacíos | POST /api/v1/pedido | campos vacíos | HTTP 400 |
| 2 | `@negative` | Origen fuera de Colombia | POST /api/v1/pedido | origen = Buenos Aires, Argentina | HTTP 400 |
| 3 | `@negative` | Destino fuera de Colombia | POST /api/v1/pedido | destino = Buenos Aires, Argentina | HTTP 400 |
| 4 | `@negative` | Peso por debajo del mínimo | POST /api/v1/pedido | peso = 0.0009 | HTTP 400 |
| 5 | `@negative` | Peso por encima del máximo | POST /api/v1/pedido | peso = 70.001 | HTTP 400 |
| 6 | `@negative` | Sin campo prioridad | POST /api/v1/pedido | sin prioridad | HTTP 400 |
| 7 | `@smoke` | Peso límite mínimo (boundary) | POST /api/v1/pedido | peso = 0.001 | HTTP 201 |
| 8 | `@smoke` | Peso límite máximo (boundary) | POST /api/v1/pedido | peso = 70 | HTTP 201 |

#### `recomendacion-proveedor.feature`

Tags: `@smoke @regression @contract`

| # | Tag | Descripción | Endpoint | Input clave | Expected |
|---|---|---|---|---|---|
| 1 | `@smoke` | MENOR_COSTO → Local (28 000/3d) | POST /api/v1/pedido | prioridad=MENOR_COSTO, proveedores base | proveedor=Local |
| 2 | `@smoke` | MENOR_TIEMPO → DHL (1d/42 000) | POST /api/v1/pedido | prioridad=MENOR_TIEMPO, proveedores base | proveedor=DHL |
| 3 | `@regression` | Desempate costo: FedEx vs Local (28 000) → FedEx (2d < 3d) | POST /api/v1/pedido | prioridad=MENOR_COSTO, empate costo | proveedor=FedEx |
| 4 | `@regression` | Desempate tiempo: FedEx vs DHL (1d) → FedEx (35 000 < 42 000) | POST /api/v1/pedido | prioridad=MENOR_TIEMPO, empate tiempo | proveedor=FedEx |
| 5 | `@contract` | Contrato de respuesta — campos completos | POST /api/v1/pedido | pedido base válido | schema recomendacion.json válido |
| 6 | `@contract` | Recomendación principal NO está en alternativas | POST /api/v1/pedido | pedido base válido | proveedor principal ∉ alternativas[] |

#### `confirmacion-persistencia.feature`

Tags: `@smoke @regression @negative @auth`

| # | Tag | Descripción | Endpoint | Input clave | Expected |
|---|---|---|---|---|---|
| 1 | `@negative` | Sin proveedor en confirmación | POST /api/v1/pedido/confirmar | sin campo proveedor | HTTP 400 |
| 2 | `@negative` | Proveedor inválido (no calculado) | POST /api/v1/pedido/confirmar | proveedor=PaqueteExpress | HTTP 400 o 422 |
| 3 | `@smoke @auth` | Confirmación exitosa → pedido persiste | POST /api/v1/pedido/confirmar → GET /api/v1/mis-pedidos | proveedor válido del cálculo | HTTP 200, pedido en lista |

---

### Subdominio: `rutas`

#### `transformacion-coordenadas.feature`

Tags: `@regression @contract`

| # | Tag | Descripción | Endpoint | Input clave | Expected |
|---|---|---|---|---|---|
| 1 | `@regression @contract` | ORS [-74.0721, 4.7110] → backend [4.7110, -74.0721] | POST /api/v1/pedido | stub ORS con features=[[-74.0721,4.7110]] | coordenadas invertidas en respuesta |

#### `ors-error.feature`

Tags: `@regression @negative`

| # | Tag | Descripción | Endpoint | Input clave | Expected |
|---|---|---|---|---|---|
| 1 | `@negative` | ORS devuelve features=[] → respuesta controlada | POST /api/v1/pedido | stub ORS con features=[] | respuesta controlada, sin excepción propagada |
| 2 | `@negative` | ORS devuelve HTTP 500 → no falla flujo | POST /api/v1/pedido | stub ORS HTTP 500 | cotización no falla completamente |

---

## karate-config.js — variables esperadas

```js
// ambiente qa
config.usuariosBaseUrl = 'http://localhost:8081';
config.pedidosBaseUrl = 'http://localhost:8080';
config.rutasBaseUrl   = 'http://localhost:8080';
```

---

## Reglas de implementación

1. Un runner por subdominio — usa `Karate.run().relativeTo(getClass())`.
2. Features y runner viven en `src/test/java/template/<subdominio>/`.
3. `callonce` para auth en todos los escenarios autenticados.
4. No hardcodear URLs, tokens ni contraseñas.
5. Email del usuario QA con timestamp para evitar colisiones entre ejecuciones.
6. Schemas reutilizables desde `src/test/resources/schemas/<subdominio>/`.
7. Data files reutilizables desde `src/test/resources/data/<subdominio>/`.

---

## Fuera de alcance

- UI / Serenity Screenplay
- Pruebas de carga (k6)
- Pruebas exploratorias manuales
- Acceso directo a BD para verificar cifrado
- Integraciones con proveedores reales FedEx / DHL
