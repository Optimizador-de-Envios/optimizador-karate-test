# ASDD — Template Definitivo para Karate

Framework de automatización asistida por IA para convertir `requirements.md` en un proyecto Karate funcional siguiendo un baseline estable y reusable entre proyectos.

```text
Requerimiento → Spec de Automatización → Features por dominio
```

## Baseline del template

Este template queda aterrizado a estas decisiones:

- **Build tool:** Maven
- **Java:** 17
- **Karate:** 1.5.2
- **Tipo de automatización:** API-first
- **Organización:** por dominio funcional
- **Runners:** uno por dominio
- **Tags:** `@smoke`, `@regression`, `@negative`, `@auth`, `@contract`, `@wip`
- **Ambiente por defecto:** `qa`
- **Ambientes adicionales:** opcionales, solo si el proyecto o el requerimiento los piden explícitamente
- **Auth configurable:** `bearer`, `oauth`, `login`

## Scaffold pre-built

El scaffold Karate ya está incluido en el template. Al implementar un feature, solo se agregan los artefactos del dominio:

- `src/test/java/template/<dominio>/<Dominio>Runner.java`
- `src/test/java/template/<dominio>/<flujo>.feature`
- `src/test/resources/data/<dominio>/**`
- `src/test/resources/schemas/<dominio>/**`

Y, además:

- specs en `.github/specs/`

## Flujo

### Opción A — Orquestación completa

```text
/asdd-orchestrate nombre-feature
```

### Opción B — Paso a paso

```text
/generate-spec nombre-feature
```

Apruebas la spec:

```yaml
status: APPROVED
```

Luego:

```text
/implement-karate nombre-feature
```

> Sin `status: APPROVED` no se crea ni modifica automatización Karate.

## Convenciones del proyecto generado

```text
.
├── pom.xml
├── mvnw
├── mvnw.cmd
├── .mvn/
│   └── wrapper/
├── src/
│   └── test/
│       ├── java/
│       │   ├── karate-config.js
│       │   ├── logback-test.xml
│       │   └── template/
│       │       └── <dominio>/
│       │           ├── <Dominio>Runner.java
│       │           └── <flujo>.feature
│       └── resources/
│           ├── data/
│           │   └── <dominio>/
│           ├── helpers/
│           │   ├── auth/
│           │   └── common.js
│           └── schemas/
│               └── <dominio>/
└── .github/
```

## Ejecución esperada

```text
./mvnw test
./mvnw test -Dkarate.env=qa
./mvnw test -Dkarate.options="--tags @smoke"
```

## Documentación clave

- `.github/README.md`
- `.github/AGENTS.md`
- `.github/copilot-instructions.md`
- `.github/instructions/karate.instructions.md`
- `.github/specs/README.md`

## Nota sobre la versión de Karate

El template queda pinneado en **Karate 1.5.2**. Según las notas oficiales de **v1.5.0**, desde esa serie Karate requiere **Java 17** y el Maven `group-id` cambió de `com.intuit.karate` a `io.karatelabs`, mientras los imports Java siguen en `com.intuit.karate.*` en la serie `1.5.x`. Fuente oficial:

- https://github.com/karatelabs/karate/releases
