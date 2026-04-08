# Requerimiento: [Nombre del dominio o capability]

## Dominio

`[dominio-kebab-case]`

## Objetivo

Describir qué se quiere automatizar con Karate y qué valor aporta.

Ejemplos:

- validar endpoints criticos de un dominio
- cubrir regresion smoke de una capability
- automatizar errores y contratos de una API

## Sistema bajo prueba

- Tipo: `[API | UI | Hybrid]`
- Base path o capability: `[ruta, modulo o servicio]`
- Ambientes relevantes: `[qa]`

Si el proyecto realmente necesita más ambientes, listarlos explícitamente.

## Flujos a cubrir

### 1. [Nombre del flujo]

`[METHOD] [ruta o capability]`

Validar:

- `[resultado feliz esperado]`
- `[error esperado]`
- `[caso borde esperado]`

### 2. [Nombre del flujo]

`[METHOD] [ruta o capability]`

Validar:

- `[resultado feliz esperado]`
- `[error esperado]`
- `[caso borde esperado]`

## Auth

- Estrategia conocida: `[bearer | oauth | login | pendiente]`
- Detalle adicional: `[si aplica]`

Si aun no esta definida, el template debe dejar preparado el proyecto para soportar:

- `bearer`
- `oauth`
- `login`

## Datos y contratos

- Datos sinteticos requeridos: `[listar]`
- Restricciones o catalogos: `[listar]`
- Schemas esperados: `[listar si ya se conocen]`

## Criterios de automatizacion

1. El dominio debe tener su propio runner.
2. Runner y features deben vivir en la misma carpeta de dominio: `src/test/java/<package>/[dominio]/`.
3. Los datos deben quedar en `src/test/resources/data/[dominio]/`.
4. Los schemas deben quedar en `src/test/resources/schemas/[dominio]/`.
5. Deben usarse los tags del template.
6. El scaffold Karate ya está pre-built en el repo.

## Fuera de alcance

- `[flujo opcional o fase 2]`
- `[integracion no confirmada]`
- `[escenarios que no se automatizan aun]`
