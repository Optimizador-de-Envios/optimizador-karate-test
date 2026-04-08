# Requirements — Entrada del Template Karate

Este directorio contiene los requerimientos que alimentan el template definitivo de Karate.

## Flujo

```text
requirements/<feature>.md
→ /generate-spec
→ specs/<feature>.spec.md
→ /implement-karate
→ proyecto Maven/Karate listo
```

## Qué debe traer un requerimiento bueno

- dominio funcional
- endpoints o capacidades
- auth esperada si se conoce
- criterios felices, errores y bordes
- restricciones de datos

## Plantilla sugerida

Puedes partir de:

```text
.github/requirements/feature-template.md
```
