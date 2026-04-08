# Lineamientos de Ingeniería de Automatización con Karate

Este documento define las reglas obligatorias para construir suites Karate legibles, mantenibles y útiles para el negocio.

## 1. Diseño de la suite

- Organiza la suite por dominios o capacidades del sistema bajo prueba.
- Un feature debe cubrir un flujo cohesivo, no un “dump” de escenarios sin relación.
- Reutiliza autenticación, payload builders, headers y funciones comunes con `call`, `callonce` y helpers.

## 2. Legibilidad

- Los escenarios deben poder leerse como comportamiento, no como script crudo.
- Nombra features, escenarios y tags con lenguaje del dominio.
- Evita comentarios redundantes; comenta solo decisiones no obvias.

## 3. Datos y ambientes

- Cero secretos hardcodeados.
- `baseUrl`, credenciales técnicas, headers compartidos y toggles salen de `karate-config.js` o del ambiente.
- Los datos de prueba deben ser sintéticos y versionados.
- Los payloads reutilizables viven fuera del escenario cuando ayudan a reducir ruido.

## 4. Aserciones significativas

- Toda automatización debe validar resultado de negocio, no solo que “respondió 200”.
- Verifica contratos, mensajes de error, estructuras y reglas críticas.
- En respuestas complejas, valida únicamente lo estable y relevante.

## 5. Cobertura útil

- Prioriza `@smoke` para caminos críticos.
- Incluye `@negative` para validaciones, auth, errores y datos inválidos.
- Usa suites `@regression` para comportamiento amplio.
- Toda cobertura debe ser trazable a criterios de aceptación o riesgos.

## 6. Mantenibilidad

- Evita duplicación de steps.
- Si tres o más escenarios repiten estructura, abstrae.
- Separa claramente datos, helpers, features y runners.
- Mantén los runners pequeños y con responsabilidad única.

## 7. Estabilidad

- No dependas de orden de ejecución.
- No uses datos de producción.
- Minimiza la dependencia de relojes, IDs volátiles y estados compartidos.
- Si el sistema necesita precondiciones, explícitalas en setup reutilizable.

## 8. Integración continua

- Las suites deben poder ejecutarse por tags y por feature.
- Deben existir grupos claros como `smoke`, `regression` y `negative`.
- Todo cambio relevante debe estar listo para integrarse a CI.

## 9. Performance

- Si la spec incluye SLAs, documenta plan para Karate + Gatling.
- No mezcles performance con regresión funcional en la misma suite sin intención explícita.

## 10. Revisión

- Todo cambio debe responder a una spec aprobada.
- Revisa duplicación, claridad del objetivo, calidad de aserciones y riesgos cubiertos antes de cerrar.
