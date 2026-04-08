---
name: generate-spec
description: Genera una spec de automatización para el template Karate definitivo.
argument-hint: "<nombre-feature>: <descripción del flujo a automatizar>"
agent: Spec Generator
tools:
  - edit/createFile
  - read/readFile
  - search/listDirectory
  - search
---

Genera una spec de automatización Karate compatible con el template definitivo.

**Feature**: ${input:featureName:nombre del feature en kebab-case}
**Requerimiento**: ${input:requirement:descripción del flujo o "ver requirements"}

## La spec debe respetar

- Maven
- Java 17
- Karate 1.5.2
- API-first
- estructura por dominio
- runners por dominio
- auth `bearer|oauth|login`
- env por defecto `qa`
- ambientes adicionales solo si el requirement o el proyecto los piden

## Pasos

1. Si no se provee requerimiento, buscar `.github/requirements/${input:featureName}.md`
2. Leer `.github/instructions/karate.instructions.md`
3. Revisar si ya existen dominios, runners o helpers reutilizables
4. Usar `.github/skills/generate-spec/spec-template.md`
5. Guardar `.github/specs/${input:featureName}.spec.md` con `status: DRAFT`
