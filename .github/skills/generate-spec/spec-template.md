---
id: SPEC-###
status: DRAFT
feature: nombre-del-feature
created: YYYY-MM-DD
updated: YYYY-MM-DD
author: spec-generator
version: "1.0"
related-specs: []
---

# Spec: [Nombre de la Automatización]

> Estado: `DRAFT` hasta aprobación humana.
> Baseline: Maven + Java 17 + Karate 1.5.2 + API-first.

## 1. REQUERIMIENTOS

### Descripción
Resumen del flujo a automatizar y por qué importa.

### Fuente del requerimiento
Referencia al archivo `.github/requirements/<feature>.md`.

### Historias o flujos a cubrir

#### HU-01: [Título]

```text
Como:        [rol]
Quiero:      [objetivo]
Para:        [valor]

Prioridad:   Alta / Media / Baja
Estimación:  XS / S / M / L
Dominio:     [dominio funcional]
```

#### Criterios de Aceptación — HU-01

**Happy Path**
```gherkin
CRITERIO-1.1: [nombre]
  Dado que: [contexto]
  Cuando: [acción]
  Entonces: [resultado]
```

**Error Path**
```gherkin
CRITERIO-1.2: [nombre]
  Dado que: [contexto]
  Cuando: [acción inválida]
  Entonces: [error esperado]
```

**Edge Case**
```gherkin
CRITERIO-1.3: [nombre]
  Dado que: [contexto]
  Cuando: [caso borde]
  Entonces: [resultado]
```

### Reglas de negocio
1. Regla crítica 1
2. Regla crítica 2
3. Restricción de auth, contrato o datos

## 2. DISEÑO DE AUTOMATIZACIÓN

### Baseline técnico

| Elemento | Valor |
|----------|-------|
| Build tool | Maven |
| Java | 17 |
| Karate | 1.5.2 |
| Dependency coordinate | `io.karatelabs:karate-junit5` |
| Scope base | API-first |
| Auth soportada | bearer / oauth / login |
| Env por defecto | qa |
| Envs adicionales | solo si aplican al requirement o al proyecto |

### Dominio

- Dominio principal: `[dominio]`
- Runner esperado: `src/test/java/template/[dominio]/[Domain]Runner.java`
- Package esperado del runner: `template.[dominio]`
- Features esperadas: `src/test/java/template/[dominio]/[flujo].feature`

### Sistema bajo prueba

| Tipo | Elemento | Notas |
|------|----------|-------|
| API | endpoint o capacidad | descripción |

### Artefactos esperados

| Artefacto | Ruta esperada | Propósito |
|-----------|---------------|-----------|
| Build file | `pom.xml` | configuración Maven |
| Wrapper Unix | `mvnw` | ejecución local sin depender de Maven instalado |
| Wrapper Windows | `mvnw.cmd` | ejecución local en Windows |
| Wrapper metadata | `.mvn/wrapper/` | distribución del wrapper |
| Config | `src/test/java/karate-config.js` | envs, auth y baseUrl |
| Logback | `src/test/java/logback-test.xml` | configuración de logging |
| Runner | `src/test/java/template/[dominio]/[Domain]Runner.java` | ejecución por dominio |
| Feature | `src/test/java/template/[dominio]/[flujo].feature` | escenarios del flujo |
| Data | `src/test/resources/data/[dominio]/[flujo]/` | payloads, queries, datasets |
| Schemas | `src/test/resources/schemas/[dominio]/` | validación de contratos |
| Auth helper | `src/test/resources/helpers/auth/` | bearer, oauth o login |
| Common helper | `src/test/resources/helpers/common.js` | utilidades simples |

### Tags

| Escenario | Tag |
|-----------|-----|
| Camino crítico | `@smoke` |
| Regresión amplia | `@regression` |
| Error o validación | `@negative` |
| Seguridad o permisos | `@auth` |
| Contrato | `@contract` |

### Estrategia de auth

- Tipo esperado: `bearer` / `oauth` / `login`
- Datos requeridos:
- Riesgos asociados:

### Estrategia de datos

- Datasets sintéticos requeridos
- Precondiciones
- Datos válidos
- Datos inválidos

### Notas de implementación

- El scaffold ya está pre-built en el repo
- Los tags controlan ejecución; las carpetas controlan organización
- Reutilizar helpers, data y schemas antes de duplicar

## 3. LISTA DE TAREAS

### Dominio

- [ ] Crear runner del dominio
- [ ] Crear feature principal
- [ ] Crear escenarios negativos
- [ ] Crear data files
- [ ] Crear schemas reutilizables
- [ ] Etiquetar escenarios con la convención estándar

### Validación

- [ ] Validar trazabilidad entre criterios y escenarios Karate
- [ ] Validar selección correcta de tags
