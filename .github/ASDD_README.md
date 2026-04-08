# ASDD Framework — Guía de Uso para GitHub Copilot

Esta versión de ASDD es un template **definitivo** para proyectos Karate con baseline compartido:

- Maven
- Java 17
- Karate 1.5.2
- API-first
- estructura por dominio
- runners por dominio

```text
Requerimiento → Spec → Features por dominio
```

## Qué problema resuelve

Que en un proyecto nuevo puedas entregar solo un `requirements.md` y que ASDD:

1. genere la spec
2. implemente features, data files, helpers, schemas y runners sobre el scaffold existente

## Requisitos

| Requisito | Detalle |
|---|---|
| VS Code | versión reciente |
| GitHub Copilot Chat | instalado |
| Setting | `github.copilot.chat.codeGeneration.useInstructionFiles: true` |

## Baseline del template

### Stack

| Elemento | Decisión |
|---|---|
| Build tool | Maven |
| Java | 17 |
| Karate | 1.5.2 |
| Scope base | API-first |

### Organización

| Elemento | Decisión |
|---|---|
| Features | por dominio |
| Runners | por dominio |
| Datos | por dominio/flujo |
| Schemas | por dominio |
| Auth | `bearer`, `oauth`, `login` |
| Env por defecto | `qa` |
| Envs adicionales | solo si el proyecto o el requerimiento los necesitan |

### Tags estándar

- `@smoke`
- `@regression`
- `@negative`
- `@auth`
- `@contract`
- `@wip`

## Flujo ASDD Karate

### Paso 1 — Requerimiento

Crear un archivo en `.github/requirements/<feature>.md`.

Puedes partir de `.github/requirements/feature-template.md`.

### Paso 2 — Spec

```text
/generate-spec <feature>
```

La spec se guarda en `.github/specs/<feature>.spec.md` con `status: DRAFT`.

### Paso 3 — Aprobación

Cambiar:

```yaml
status: DRAFT
```

por:

```yaml
status: APPROVED
```

### Paso 4 — Implementación Karate

```text
/implement-karate <feature>
```

Cuando un dominio se implementa, runner y features van juntos:
- `src/test/java/template/<dominio>/<Dominio>Runner.java`
- `src/test/java/template/<dominio>/<flujo>.feature`

## Estructura exacta esperada

Basada en el archetype oficial de Karate. Runner y feature viven en la misma carpeta de dominio.

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
│           ├── data/<dominio>/<flujo>/
│           ├── helpers/
│           │   ├── auth/
│           │   └── common.js
│           └── schemas/<dominio>/
└── .github/
```

## Comandos esperados

```text
./mvnw test
./mvnw test -Dkarate.env=qa
./mvnw test -Dkarate.options="--tags @smoke"
./mvnw test -Dtest="template.<dominio>.<Dominio>Runner"
```

## Agentes disponibles

| Agente | Responsabilidad |
|---|---|
| `@Orchestrator` | Coordina spec → implementación Karate |
| `@Spec Generator` | Convierte requerimientos en specs de automatización |
| `@Karate Engineer` | Genera y mantiene el proyecto Karate |

## Skills disponibles

| Skill | Qué hace |
|---|---|
| `/asdd-orchestrate` | flujo completo |
| `/generate-spec` | spec de automatización |
| `/implement-karate` | implementación Karate |

## Reglas de oro

1. No automatizar sin spec `APPROVED`.
2. No generar código de producto.
3. El scaffold Karate ya está pre-built en el template.
4. Organizar por dominio, no por tipo de suite.
5. Los tags deciden ejecución; las carpetas deciden ownership y mantenimiento.
6. Auth y ambiente salen de `karate-config.js`, nunca hardcodeados.
7. El package de los runners es `template.<dominio>`.

## Referencia de versión

El template queda pinneado en Karate `1.5.2`. Según las notas oficiales de `v1.5.0`, la serie `1.5.x` requiere Java 17 y cambia el `group-id` Maven a `io.karatelabs`, aunque los imports Java se mantienen en `com.intuit.karate.*` en esa serie:

- https://github.com/karatelabs/karate/releases
