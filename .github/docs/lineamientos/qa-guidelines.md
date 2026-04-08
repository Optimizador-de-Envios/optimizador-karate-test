# Guía de QA para Automatización con Karate

Este documento consolida prácticas de QA para diseñar y validar automatización con Karate bajo un enfoque AI-first y risk-based.

## 1. Shift-left

- Revisar requerimientos temprano para detectar ambigüedades antes de automatizar.
- Confirmar criterios de aceptación, datos, auth, errores esperados y precondiciones.
- Si no existe claridad suficiente, primero se corrige la spec, no la suite.

## 2. Diseño de escenarios

- Redactar Gherkin con foco en comportamiento observable.
- Cubrir happy path, error path y casos borde.
- Mapear cada escenario a un riesgo o criterio relevante.

## 3. Priorización por riesgo

- Los riesgos altos deben tener cobertura obligatoria.
- Auth, datos sensibles, integraciones externas y operaciones irreversibles son prioridad.
- Lo estético o administrativo puede quedar fuera de `smoke`.

## 4. Automatización con propósito

- Karate debe usarse para cubrir flujos valiosos y repetibles.
- No automatices por volumen: automatiza por impacto, estabilidad y retorno.
- Los escenarios deben aportar señal diagnóstica cuando fallan.

## 5. Datos de prueba

- Siempre sintéticos, trazables y desacoplados del código cuando sea razonable.
- Documentar datasets especiales, catálogos válidos e inválidos y límites.

## 6. Cobertura y trazabilidad

- Toda suite debe poder responder qué HU, criterio o riesgo cubre.
- Usa tags consistentes para filtrar smoke, regression, negative, auth y perf.
- Mantén documentos de cobertura cuando el flujo lo requiera.

## 7. Performance

- Si hay SLAs, planificar performance con Karate + Gatling.
- Separar claramente performance de regresión funcional.
- Documentar ambiente, datos, umbrales y brechas respecto a producción.

## 8. DoR de automatización

Antes de automatizar:

- [ ] Requerimiento o spec entendible
- [ ] Criterios claros
- [ ] Ambiente identificable
- [ ] Datos definidos
- [ ] Viabilidad técnica comprobada

## 9. DoD de automatización

Un entregable se considera terminado cuando:

- [ ] Sigue la spec aprobada
- [ ] Reutiliza patrones Karate del proyecto
- [ ] Tiene aserciones útiles
- [ ] La cobertura está justificada
- [ ] Está listo para ejecutarse en CI
