# AGENTS.md — ASDD Karate Template

Guía compartida para todos los agentes del template definitivo de Karate.

## Baseline obligatorio

- Maven
- Java 17
- Karate 1.5.2
- API-first
- estructura por dominio
- runners por dominio

## Workflow

```text
[1] Spec Generator
→ .github/specs/<feature>.spec.md

[2] Karate Engineer
→ features, data, helpers, schemas, runners
```

## Contexto obligatorio a cargar

| Documento | Ruta |
|---|---|
| Reglas globales | `.github/AGENTS.md` |
| Instrucciones globales | `.github/copilot-instructions.md` |
| Layout real del template | `.github/instructions/karate.instructions.md` |
| Ingeniería de automatización | `.github/docs/lineamientos/dev-guidelines.md` |
| Estrategia QA | `.github/docs/lineamientos/qa-guidelines.md` |

## Reglas de oro

1. Sin spec `APPROVED`, no hay implementación.
2. El scaffold Karate ya está pre-built en el template.
3. Todo se organiza por dominio.
4. Los tags controlan ejecución y prioridad, no estructura de carpetas.
5. `karate-config.js` es la única fuente de ambientes y auth.
6. Soportar auth `bearer`, `oauth` y `login`.
7. Usar `qa` como ambiente por defecto; agregar otros solo si el requirement o el contexto del proyecto lo justifican.
8. No generar backend, frontend ni código del sistema bajo prueba.

## Estructura objetivo

Basada en el archetype oficial de Karate. Runner y feature **viven en la misma carpeta de dominio**.

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
