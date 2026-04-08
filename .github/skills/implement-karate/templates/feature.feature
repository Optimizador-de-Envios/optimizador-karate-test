# language: es
Característica: [Nombre del flujo del dominio]

  Antecedentes:
    * def authResult = callonce read('classpath:helpers/auth/auth.feature') { baseUrl: baseUrl, auth: auth }
    * url baseUrl
    * header Authorization = 'Bearer ' + authResult.token

  @smoke @contract
  Escenario: [camino feliz]
    Dado path '[recurso]'
    Y params read('classpath:data/[dominio]/[flujo]/valid-query.json')
    Cuando method get
    Entonces status 200
    Y match response == read('classpath:schemas/[dominio]/[flujo]-response.json')

  @negative @auth
  Escenario: [token inválido o ausente]
    Dado path '[recurso]'
    Y header Authorization = 'Bearer invalid-token'
    Cuando method get
    Entonces status 401

  @negative
  Escenario: [validación de parámetros]
    Dado path '[recurso]'
    Y params read('classpath:data/[dominio]/[flujo]/invalid-query.json')
    Cuando method get
    Entonces status 422
