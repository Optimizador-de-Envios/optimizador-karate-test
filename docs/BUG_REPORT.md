# Bug Report — Optimizador de Envíos
## Hallazgos encontrados durante la ejecución de pruebas con Karate DSL

**Proyecto:** Optimizador de Envíos  
**QA Engineer:** [Nahuel Lemes](https://github.com/nahulemesf)
**Ambiente:** QA (`http://localhost:8080` shipment-service · `http://localhost:8081` user-service)  
**Versión de Karate:** 1.5.2  
**Estado final del suite:** ✅ BUILD SUCCESS — 19 escenarios pasados, 0 fallidos (excluyendo `@wip`)

## Reporte HTML

![Reporte HTML](/docs/html_report.png)

---

## Resumen

Durante la implementación y ejecución del suite de pruebas Karate encontré **2 discrepancias** entre el contrato real del API documentado en los README de cada servicio (`shipment-service/README.md` y `user-service/README.md`) y el PRD. Estas discrepancias se traducen en comportamientos del API que **no cumplen con lo que el PRD exige**, lo que representa un riesgo de negocio y una brecha de calidad que debería corregirse.

Los bugs que dependen de cambios en el backend quedaron documentados como **abiertos** y sus escenarios los marqué con `@wip` (ver sección al final del documento).

| ID | Categoría | Severidad | Estado |
|---|---|---|---|
| BUG-001 | Conflicto PRD vs. README | 🟡 Alto | ⚠️ Abierto — requiere cambio en backend |
| BUG-002 | Geo-validación de Colombia | 🔴 Crítico | ⚠️ Abierto — requiere cambio en backend · escenarios marcados `@wip` |

---

## Detalle de bugs

---

### BUG-001 — `POST /api/v1/pedido` documentado como no protegido, pero el PRD exige autenticación

| Campo | Detalle |
|---|---|
| **ID** | BUG-001 |
| **Severidad** | 🟡 Alto |
| **Servicio** | `shipment-service` |
| **Endpoint** | `POST /api/v1/pedido` |
| **Estado** | ⚠️ Abierto — requiere cambio en backend |

**Descripción:**  
El README de `shipment-service` declara explícitamente para este endpoint: **"Protegido: no"**. La **Regla 23 del PRD**, en cambio, establece que el usuario debe estar autenticado para registrar un pedido.

Siguiendo el PRD, inicialmente escribí los tests enviando JWT en `POST /api/v1/pedido`. El API no lo rechazaba, pero tampoco lo exigía. Al leer el README y confirmar que el endpoint es público por diseño, ajusté los tests para omitir el header `Authorization` en la cotización.

Tal como lo documenta el README, `POST /api/v1/pedido/confirmar` sí está protegido, pero no existe un cumplimiento adecuado a lo que el PRD exige para la cotización.

**Corrección aplicada en tests:** Eliminé el header `Authorization` de los escenarios de `registro-pedido.feature` y `recomendacion-proveedor.feature`.

**Recomendación:** Implementar autenticación en `POST /api/v1/pedido`. La falta de autenticación en la cotización es un riesgo de seguridad, y no se alinea con la idea de que cada pedido debe estar asociado a un usuario.

---

### BUG-002 — Geo-validación de Colombia no implementada, requerida por PRD ⚠️ ABIERTO

| Campo | Detalle |
|---|---|
| **ID** | BUG-002 |
| **Severidad** | 🔴 Crítico |
| **Servicio** | `shipment-service` |
| **Endpoint** | `POST /api/v1/pedido` |
| **Estado** | ⚠️ Abierto — requiere cambio en backend · escenarios marcados `@wip` |

**Descripción:**  
La **Regla 1 del PRD** establece que el sistema solo debe operar para envíos dentro de Colombia. Escribí escenarios que envían coordenadas de Buenos Aires (Argentina) y esperan `HTTP 400` como rechazo.

El README de `shipment-service` no documenta ninguna validación geográfica. Al ejecutar los tests, el API procesó las coordenadas fuera de Colombia y devolvió `HTTP 200` con cotización:

```
status code was: 200, expected: 400
response: { "recommendation": { "providerName": "FedEx", "cost": 446262.90, ... } }
```

Esto representa un incumplimiento **crítico** del PRD, ya que el sistema estaría aceptando pedidos que no debería procesar, lo que podría generar problemas logísticos y de satisfacción al cliente.

**Recomendación:** Implementar validación de bounding box de Colombia en el backend (lat: 1.5°N–12.5°N, lng: -79°W–-66°W) y documentar la validación en el README del servicio cuando esté lista.

---

## Por qué usé `@wip`

Decidí marcar con `@wip` los escenarios que no pueden ejecutarse todavía por factores externos a los tests: un bug no corregido en el backend o la ausencia de infraestructura de soporte en QA (stubs). El tag `@wip` excluye esos escenarios del runner principal `AllRunner` pero los mantiene vivos en el repositorio como contrato documentado de lo que debe cubrirse cuando el bloqueante se resuelva. Para reactivarlos basta con quitar el tag.

No los eliminé ni los hice pasar artificialmente con expectativas incorrectas — eso hubiera ocultado deuda real.

| Feature | Escenario | Bloqueante |
|---|---|---|
| `registro-pedido.feature` | Origen fuera de Colombia → HTTP 400 | BUG-002: geo-validación no implementada |
| `registro-pedido.feature` | Destino fuera de Colombia → HTTP 400 | BUG-002: geo-validación no implementada |
| `recomendacion-proveedor.feature` | Desempate por tiempo ante empate en costo | Requiere mock de proveedores con valores fijos en QA |
| `recomendacion-proveedor.feature` | Desempate por costo ante empate en tiempo | Requiere mock de proveedores con valores fijos en QA |
| `rutas/transformacion-coordenadas.feature` | Conversión ORS `[lng, lat]` a Leaflet `[lat, lng]` | Requiere stub de OpenRouteService activo en QA |
| `rutas/ors-error.feature` | Manejo de error de OpenRouteService | Requiere stub de ORS configurado con falla en QA |

---

## Estado del suite por dominio

| Dominio | Features | Escenarios ejecutados | Pasados | Fallidos | Saltados (`@wip`) |
|---|---|---|---|---|---|
| `usuarios` | 2 | 6 | 6 | 0 | 0 |
| `pedidos` | 3 | 13 | 13 | 0 | 4 |
| `rutas` | 2 | 0 | 0 | 0 | 2 |
| **Total** | **7** | **19** | **19** | **0** | **6** |

---

## Recomendaciones generales

1. **Ajustar el backend a los requerimientos del PRD:** Especialmente en lo que respecta a autenticación y validación geográfica. El PRD es el contrato de negocio principal, y el backend debe alinearse con él.
2. **Mantener los README actualizados:** El README de cada servicio debe reflejar fielmente el contrato actual del API. Si el backend implementa autenticación o validación geográfica, el README debe documentarlo claramente.

## Consideraciones para el futuro

1. **Implementar stubs/mocks para dependencias externas:** Para escenarios que dependen de servicios externos (como ORS o proveedores de envío), es crucial tener stubs o mocks configurados en el ambiente de QA para poder ejecutar esos tests de manera confiable.
2. **Revisar regularmente los escenarios `@wip`:** Para asegurarse de que se reactivan tan pronto como se resuelvan los bloqueantes, evitando que queden olvidados.
