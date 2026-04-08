# Lineamientos Rápidos de Karate
# Versión: 2.0.0
# Última actualización: 2026-03-28

## 1. Estructura

Basada en el archetype oficial de Karate. Runner y feature viven en la misma carpeta de dominio.

```text
src/test/java/template/<dominio>/<Dominio>Runner.java
src/test/java/template/<dominio>/<feature>.feature
src/test/resources/data/<dominio>/<feature>/*.json
src/test/resources/helpers/*.js
src/test/java/karate-config.js
src/test/java/logback-test.xml
```

## 2. Tags estándar

- `@smoke` → camino crítico
- `@regression` → cobertura amplia
- `@negative` → validaciones y errores
- `@auth` → seguridad y autorización
- `@perf` → performance
- `@wip` → trabajo en curso, no para CI estable

## 3. Reglas de diseño

- Un flujo coherente por feature
- Reutilizar `call`, `callonce` y helpers
- Nada de secretos hardcodeados
- Datos sintéticos y externos cuando sean reutilizables

## 4. Aserciones mínimas

- Código HTTP esperado
- Payload o contrato relevante
- Regla de negocio asociada
- Mensaje de error cuando aplique

## 5. Quality gates sugeridos

- 0 escenarios smoke fallidos
- 0 escenarios auth críticos fallidos
- Sin duplicación evidente de setup
- Sin URLs ni tokens hardcodeados
- Suites ejecutables por tag
