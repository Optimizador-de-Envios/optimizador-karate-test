# Copilot Instructions

## Template definitivo Karate

Este repositorio define un template ASDD para proyectos Karate con baseline fijo:

- Maven
- Java 17
- Karate 1.5.2
- API-first
- estructura por dominio
- runners por dominio

## Flujo

```text
[Orchestrator] → [Spec Generator] → [Karate Engineer]
```

## Convenciones fijas

### Ambientes

- `qa`

`qa` es el default.
Ambientes adicionales solo deben aparecer si el requirement o el proyecto los piden explícitamente.

### Tags

- `@smoke`
- `@regression`
- `@negative`
- `@auth`
- `@contract`
- `@wip`

### Auth soportada

- `bearer`
- `oauth`
- `login`

## Estructura de proyecto esperada

Basada en el archetype oficial de Karate (`karate-archetype`). Runner y feature **viven en la misma carpeta de dominio**.

```text
pom.xml
mvnw
mvnw.cmd
.mvn/wrapper/
src/test/java/karate-config.js
src/test/java/logback-test.xml
src/test/java/template/<dominio>/<Dominio>Runner.java
src/test/java/template/<dominio>/<flujo>.feature
src/test/resources/data/<dominio>/<flujo>/
src/test/resources/helpers/
src/test/resources/schemas/<dominio>/
```

## Reglas globales

- No automatizar sin spec aprobada
- No generar código de producto
- Reutilizar helpers, data files y schemas antes de duplicar

## Referencia de versión

Se usa Karate `1.5.2` como baseline del template. Según las notas oficiales de Karate Labs, `v1.5.0` requiere Java 17 y cambia el `group-id` Maven a `io.karatelabs`, mientras la serie `1.5.x` mantiene los imports Java en `com.intuit.karate.*`:

- https://github.com/karatelabs/karate/releases
