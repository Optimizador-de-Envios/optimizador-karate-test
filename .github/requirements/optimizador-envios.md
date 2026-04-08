# Requerimiento: Optimizador de Envíos — Automatización API Karate

## Dominio

`optimizador-envios`

Subdominios funcionales con runner independiente:

| Subdominio | Paquete Java | Servicio |
|---|---|---|
| `usuarios` | `template.usuarios` | `http://localhost:8081` |
| `pedidos` | `template.pedidos` | `http://localhost:8080` |
| `rutas` | `template.rutas` | `http://localhost:8080` |

## Objetivo

Automatizar con Karate DSL los endpoints REST del Optimizador de Envíos corriendo en Docker (QA local).
Cubrir flujos críticos de: registro y login de usuarios, ciclo completo de pedido con prioridad y recomendación de proveedor, confirmación y persistencia, y manejo de rutas ORS.

## Sistema bajo prueba

- Tipo: `API`
- Ambientes relevantes: `qa`
- Servicios:
  - `user-service` → `http://localhost:8081` — rutas `/api/users/*`
  - `shipment-service` → `http://localhost:8080` — rutas `/api/v1/*`

---

## Flujos a cubrir

### Subdominio: `usuarios`

#### 1. Registro de usuario

`POST /api/users/register`

Validar:

- `HTTP 409` si el correo ya existe en base (correo duplicado)
- `HTTP 400` si faltan campos obligatorios: nombre, correo o contraseña
- `HTTP 400` si la contraseña tiene menos de 8 caracteres
- Verificación indirecta de cifrado: registrar usuario → hacer login exitoso → confirma que la contraseña fue hasheada correctamente (acceso directo a BD fuera de alcance Karate)

#### 2. Login de usuario

`POST /api/users/login`

Validar:

- `HTTP 401` si las credenciales son inválidas (correo o contraseña incorrectos)
- Happy path de login como prerequisito de auth (`callonce`) para flujos autenticados de shipment-service

---

### Subdominio: `pedidos`

#### 3. Registro de pedido — validaciones de entrada

`POST /api/v1/pedido`

Validar:

- `HTTP 400` si origen, destino y peso están vacíos
- `HTTP 400` si origen o destino están fuera de Colombia
- `HTTP 400` si el peso es `< 0.001` Kg (inferior al mínimo)
- `HTTP 400` si el peso es `> 70` Kg (superior al máximo)
- `HTTP 400` si no se envía el campo `prioridad`
- `HTTP 201` si el peso es exactamente `0.001` Kg (límite mínimo aceptado)
- `HTTP 201` si el peso es exactamente `70` Kg (límite máximo aceptado)

#### 4. Recomendación de proveedor

`POST /api/v1/pedido`

Validar:

- Prioridad `MENOR_COSTO` → recomienda al proveedor de menor costo (`Local = 28 000 COP / 3d`)
- Prioridad `MENOR_TIEMPO` → recomienda al proveedor de menor tiempo (`DHL = 1d / 42 000 COP`)
- Desempate por tiempo ante empate en costo: `FedEx 28 000/2d` vs `Local 28 000/3d` → gana `FedEx`
- Desempate por costo ante empate en tiempo: `FedEx 35 000/1d` vs `DHL 42 000/1d` → gana `FedEx`
- Contrato de respuesta incluye campos: `proveedor`, `costo`, `tiempoEntrega`, `prioridad`, `alternativas`
- La recomendación principal **no** aparece duplicada dentro de `alternativas`

#### 5. Confirmación de proveedor y persistencia

`POST /api/v1/pedido/confirmar`  
`GET /api/v1/mis-pedidos`

Validar:

- `HTTP 400` si no se envía proveedor en la confirmación
- `HTTP 400` o `HTTP 422` si el proveedor enviado no pertenece a las opciones calculadas (proveedor inválido)
- Pedido confirmado queda persistido y asociado al usuario del JWT (verificar vía `GET /api/v1/mis-pedidos`)

---

### Subdominio: `rutas`

#### 6. Transformación de coordenadas ORS → Leaflet

`POST /api/v1/pedido` (respuesta del backend — transformación interna)

Validar:

- Las coordenadas en la respuesta del backend están en formato `[lat, lng]`, no `[lng, lat]` como retorna ORS
- Usar stub controlado con `features = [[-74.0721, 4.7110]]` y verificar que el backend invierte a `[4.7110, -74.0721]`

#### 7. Manejo de error de OpenRouteService

`POST /api/v1/pedido` (con stub ORS en falla)

Validar:

- Si el stub de ORS responde `HTTP 500`, timeout o `features = []`, el sistema retorna una respuesta controlada
- No se propaga una excepción no manejada al cliente
- El flujo de cotización no falla completamente por fallo de ORS

---

## Auth

- Estrategia conocida: `login`
- Detalle:
  - `POST /api/users/login` con `{ "email": "...", "password": "..." }` retorna JWT
  - El token se usa como `Authorization: Bearer <token>` en todos los endpoints de `shipment-service`
  - **No existe usuario semilla** en el ambiente Docker; el helper de auth debe:
    1. `POST /api/users/register` para crear el usuario de prueba
    2. `POST /api/users/login` para obtener el JWT
    3. Usar `callonce` para no repetir en cada escenario

---

## Datos y contratos

- Datos sintéticos requeridos:
  - Usuario de prueba: `{ "nombre": "Usuario QA", "email": "qa.test+<timestamp>@example.com", "password": "Password123" }` (email con timestamp para evitar duplicados entre ejecuciones)
  - Pedido base válido: `{ "origen": "Bogotá, Colombia", "destino": "Medellín, Colombia", "peso": 5, "prioridad": "MENOR_COSTO" }`
  - Pedido fuera de cobertura — caso A: origen `"Buenos Aires, Argentina"`, destino `"Medellín, Colombia"`
  - Pedido fuera de cobertura — caso B: origen `"Bogotá, Colombia"`, destino `"Buenos Aires, Argentina"`
  - Peso límite mínimo válido: `0.001`
  - Peso límite máximo válido: `70`
  - Peso inferior al mínimo: `0.0009`
  - Peso superior al máximo: `70.001`
  - Proveedores mock base: `FedEx 35 000/2d`, `DHL 42 000/1d`, `Local 28 000/3d`
  - Proveedores mock empate en costo: `FedEx 28 000/2d`, `DHL 42 000/1d`, `Local 28 000/3d`
  - Proveedores mock empate en tiempo: `FedEx 35 000/1d`, `DHL 42 000/1d`, `Local 28 000/3d`
  - Stub ORS error: `{ "features": [] }` o response HTTP 500
  - Usuario con correo pre-existente (semilla de registro previo en el mismo test, no en BD)

- Restricciones o catálogos:
  - `email` debe ser único por ejecución → usar timestamp o UUID
  - Rango de peso aceptado: `[0.001, 70]` Kg
  - Origen y destino deben ser ciudades de Colombia para flujos de pedido válido
  - Prioridades válidas: `MENOR_COSTO`, `MENOR_TIEMPO`
  - Proveedores conocidos: `FedEx`, `DHL`, `Local`

- Schemas esperados:
  - `schemas/pedidos/recomendacion.json` — campos `proveedor`, `costo`, `tiempoEntrega`, `prioridad`, `alternativas[]`
  - `schemas/pedidos/confirmar-response.json` — respuesta de confirmación exitosa
  - `schemas/usuarios/registro-response.json` — respuesta de creación de usuario
  - `schemas/usuarios/login-response.json` — respuesta con campo `token`

---

## Criterios de automatización

1. Cada subdominio (`usuarios`, `pedidos`, `rutas`) debe tener su propio runner.
2. Runner y features deben vivir en la misma carpeta de dominio: `src/test/java/template/<subdominio>/`.
3. Los datos deben quedar en `src/test/resources/data/<subdominio>/`.
4. Los schemas deben quedar en `src/test/resources/schemas/<subdominio>/`.
5. Los helpers de auth (registro + login) deben quedar en `src/test/resources/helpers/auth/`.
6. Deben usarse los tags del template: `@smoke`, `@regression`, `@negative`, `@auth`, `@contract`, `@wip`.
7. El scaffold Karate ya está pre-built en el repo; reutilizar `pom.xml`, `mvnw`, `karate-config.js` y helpers existentes.
8. Las URLs base (`http://localhost:8081` y `http://localhost:8080`) deben configurarse en `karate-config.js` bajo el ambiente `qa`.
9. No hardcodear URLs, tokens ni contraseñas en las features.

---

## Fuera de alcance

- `TC-HU01-01`, `TC-HU01-02`, `TC-HU01-09` — Formulario web y autocompletado (Serenity Screenplay / UI)
- `TC-HU02-01` — Selección de prioridad en UI (Serenity Screenplay)
- `TC-HU04-01`, `TC-HU04-02` — Visualización de alternativas en UI (Serenity Screenplay)
- `TC-HU05-01` — Selección de proveedor en UI (Serenity Screenplay)
- `TC-HU06-01`, `TC-HU06-02`, `TC-HU06-04`, `TC-HU06-06` — Visualización y comportamiento del mapa Leaflet (Serenity Screenplay / manual)
- `TC-HU07-01`, `TC-HU08-01` — Flujos UI de registro y login (Serenity Screenplay)
- `TC-HU01-10`, `TC-HU03-06`, `TC-HU05-05` — Pruebas de carga (k6)
- `TC-HU03-07`, `TC-HU07-06` — Pruebas exploratorias manuales
- Verificación directa de contraseña cifrada en BD (requiere acceso JDBC fuera del alcance actual)
- Integraciones con proveedores reales FedEx / DHL (solo mock en QA)
