---
name: implement-karate
description: Implementa features Karate sobre el scaffold pre-built del template.
argument-hint: "<nombre-feature>"
---

# Implement Karate

## Baseline del template

- Maven
- Java 17
- Karate 1.5.2
- API-first
- runners por dominio

## Prerequisitos

1. Leer `.github/specs/<feature>.spec.md`
2. Leer `.github/instructions/karate.instructions.md`

## Scaffold pre-built

El scaffold ya existe en el repo template. No es necesario verificarlo ni recrearlo. Los archivos base son:

- `pom.xml` — con `<testResources>` para `src/test/java` excluyendo `**/*.java`
- `mvnw`, `mvnw.cmd`, `.mvn/wrapper/maven-wrapper.properties`
- `src/test/java/karate-config.js`
- `src/test/java/logback-test.xml`
- `src/test/java/template/` — package base del template
- `src/test/resources/helpers/auth/` — auth.feature, oauth.feature, login.feature
- `src/test/resources/helpers/common.js`
- `src/test/resources/data/`
- `src/test/resources/schemas/`

## Orden recomendado

```text
Reutilizar scaffold existente
→ Verificar que el package base sea `template`
→ config (karate-config.js ya en src/test/java/)
→ auth/common helpers (ya en src/test/resources/helpers/)
→ data files en src/test/resources/data/<dominio>/
→ schemas en src/test/resources/schemas/<dominio>/
→ features + runner del dominio en src/test/java/template/<dominio>/
```

## Convenciones

- Organización por dominio
- **Runner y features viven en la misma carpeta**: `src/test/java/template/<dominio>/`
- El runner usa `Karate.run().relativeTo(getClass())` para descubrir features
- Package del runner: `template.<dominio>` (no `.runners`, no derivar del `groupId`)
- `karate-config.js` vive en `src/test/java/`, NO en la raíz
- Tags estándar del template
- Auth configurable: `bearer`, `oauth`, `login`
- Env por defecto: `qa`
- Envs adicionales: solo si el requirement o el proyecto los necesitan
- Para Karate `1.5.x`, `pom.xml` debe usar `io.karatelabs:karate-junit5`
- Los imports Java pueden seguir en `com.intuit.karate.*` en la serie `1.5.x`
- `pom.xml` debe incluir `<testResources>` con `src/test/java` excluyendo `**/*.java`
- **No hardcodear paths de endpoints**: los paths de API (e.g. `/productsList`, `/brandsList`) NUNCA van literales en el `.feature`. Deben definirse como variables en `karate-config.js` (dentro de un objeto `paths` por dominio) y usarse en el feature como `Given path paths.productsList`. Ejemplo en config:
  ```js
  paths: {
    productsList: '/api/productsList',
    brandsList: '/api/brandsList'
  }
  ```
  Ejemplo en feature:
  ```gherkin
  Given path paths.productsList
  ```
- **Payloads desde archivos JSON**: los features NUNCA deben definir payloads inline ni construir JSON con `def` dentro del feature. En su lugar deben leer el contenido desde archivos `.json` ubicados en `src/test/resources/data/<dominio>/` usando `read('classpath:data/<dominio>/<archivo>.json')`. Ejemplo:
  ```gherkin
  * def payload = read('classpath:data/automationexercise/searchProduct.json')
  And request payload
  ```
- **Form fields en bloque, NUNCA campo a campo**: cuando un endpoint recibe `form-data`, se DEBE usar `And form fields <variable>` (plural) pasándole el objeto JSON completo leído del data file. NUNCA usar `And form field` (singular) repetido por cada campo. Ejemplo correcto:
  ```gherkin
  * def createData = read('classpath:data/automationexercise/user/create-account.json')
  Given path paths.createAccount
  And form fields createData
  When method post
  ```
  Ejemplo **PROHIBIDO** (no generar esto):
  ```gherkin
  And form field name = createData.name
  And form field email = createData.email
  And form field password = createData.password
  ...
  ```


## Regla obligatoria de wrapper

- Si el proyecto no tiene `mvnw`, `mvnw.cmd` y `.mvn/wrapper/`, debes generarlos.
- Preferir Maven Wrapper estándar en vez de inventar scripts manuales.
- El proyecto debe quedar ejecutable con `./mvnw test`.

## Restricciones

- No escribir código de producto
- No convertir el template en multi-stack
