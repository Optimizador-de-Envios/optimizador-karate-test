---
name: full-flow
description: Orquesta el flujo completo del template Karate definitivo.
agent: Orchestrator
---

Inicia el flujo completo ASDD Karate.

**Feature**: ${input:featureName:nombre del feature en kebab-case}
**Requerimiento**: ${input:requirement:descripción del flujo a automatizar}

## El flujo debe respetar

- Maven
- Java 17
- Karate 1.5.2
- API-first
- dominio funcional
- runner por dominio

## El @Orchestrator ejecuta

1. `Spec Generator`
2. aprobación humana
3. `Karate Engineer` para implementación
