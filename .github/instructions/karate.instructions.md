---
applyTo: "pom.xml,karate-config.js,src/test/java/**/*.feature,src/test/java/**/*.java,src/test/resources/**/*.json,src/test/resources/**/*.js,src/test/resources/**/*.feature"
---

# Instrucciones para el Template Karate

## Baseline fijo

- Maven
- Java 17
- Karate 1.5.2
- Core API-first

## Regla de dependencia

- Para Karate `1.5.x`, usar `io.karatelabs:karate-junit5` en `pom.xml`.
- En esa misma serie, los imports Java siguen siendo `com.intuit.karate.*`.

## Estructura exacta

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
src/test/resources/data/<dominio>/<flujo>/*.json
src/test/resources/helpers/auth/*.feature
src/test/resources/helpers/common.js
src/test/resources/schemas/<dominio>/*.json
```

## Organización

- Las carpetas representan dominio funcional.
- Los tags representan intención de ejecución.
- Un dominio puede tener múltiples features.
- Un runner por dominio.
- **Runner y features deben vivir en la misma carpeta de dominio** (nunca separados).
- El runner usa `Karate.run().relativeTo(getClass())` para descubrir features automáticamente.
- El package Java del runner siempre es `template.<dominio>` (carpeta `src/test/java/template/<dominio>/`).
- `karate-config.js` y `logback-test.xml` viven en `src/test/java/`, NO en la raíz del proyecto.
- `pom.xml` debe incluir `<testResources>` con `src/test/java` (excluyendo `**/*.java`) para que los `.feature` estén en el classpath.

## Tags obligatorios del template

- `@smoke`
- `@regression`
- `@negative`
- `@auth`
- `@contract`
- `@wip`

## Ambiente por defecto del template

- `qa`

`qa` debe ser el default en `karate-config.js`.
Ambientes adicionales solo deben agregarse cuando el requirement o el proyecto los necesiten de verdad.

## Estrategias de auth soportadas

- `bearer`
- `oauth`
- `login`

La estrategia debe resolverse desde `karate-config.js` y helpers de auth.

## Reglas de implementación

- El scaffold pre-built ya existe en el repo. Reutilizar los archivos base (`pom.xml`, `mvnw`, `karate-config.js`, helpers) directamente.
- Si ya existe, reutilízalo y ajústalo sin romperlo.
- El scaffold Maven debe incluir wrapper funcional.
- Preferir generar Maven Wrapper con la tooling estándar de Maven, no inventar scripts manuales.
- No mezclar coordenadas viejas `com.intuit.karate` en `pom.xml` con Karate `1.5.x`.
- Las features `.feature` viven junto al runner en `src/test/java/template/<dominio>/`, NO en `src/test/resources/features/`.
- Reutiliza `helpers`, `schemas`, `Background`, `call` y `callonce`.
- Usa `data/` para payloads y datasets reutilizables.
- Usa `schemas/` para validaciones de contrato reutilizables.
- No hardcodees URLs, tokens ni secretos.

## Ejecución esperada

```text
./mvnw test
./mvnw test -Dkarate.env=qa
./mvnw test -Dkarate.options="--tags @smoke"
```
