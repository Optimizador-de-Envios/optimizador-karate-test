---
name: karate-task
description: Implementa una automatización Karate dentro del template definitivo.
argument-hint: "<nombre-feature>"
agent: Karate Engineer
tools:
  - edit/createFile
  - edit/editFiles
  - read/readFile
  - search/listDirectory
  - search
  - execute/runInTerminal
---

Implementa la automatización Karate para el feature indicado.

**Feature**: ${input:featureName:nombre del feature en kebab-case}

## Reglas del trabajo

- Baseline: Maven + Java 17 + Karate 1.5.2
- Estructura por dominio
- Runner por dominio
- Tags estándar del template
- Auth configurable
- Para Karate 1.5.x, usa `io.karatelabs:karate-junit5` en `pom.xml` y mantén imports `com.intuit.karate.*` en Java

## Pasos

1. Lee `.github/specs/${input:featureName}.spec.md`
2. Si no está `APPROVED`, detente
3. Implementa helpers, data, schemas, features y runner del dominio
