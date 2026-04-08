---
name: generate-spec
description: Genera una spec compatible con el template Karate definitivo.
argument-hint: "<nombre-feature>: <descripción del flujo>"
---

# Generate Spec

## Baseline

- Maven
- Java 17
- Karate 1.5.2
- API-first
- estructura por dominio

## Definition of Ready

- [ ] dominio identificado
- [ ] flujo o endpoint identificado
- [ ] criterios felices, errores y bordes claros
- [ ] auth conocida o marcada como pendiente
- [ ] datos y restricciones descritos

## Restricciones

- La spec debe definir los artefactos del dominio a crear sobre el scaffold existente
- Debe definir runner por dominio, tags, data, schemas y `pom.xml` esperados
