@smoke @regression @negative
Feature: Registro de usuario — POST /api/users/register

  Background:
    * def schemaRegistro = read('classpath:schemas/usuarios/registro-response.json')

  @negative
  Scenario: Correo duplicado retorna HTTP 409
    * def timestamp = function(){ return '' + Date.now() }
    * def email = 'qa.test+' + timestamp() + '@example.com'
    * def registroBase = read('classpath:data/usuarios/registro.json')
    * set registroBase.email = email
    Given url usuariosBaseUrl
    And path paths.usuarios.register
    And request registroBase
    When method post
    Then status 201
    Given url usuariosBaseUrl
    And path paths.usuarios.register
    And request registroBase
    When method post
    Then status 409

  @negative
  Scenario: Campos obligatorios vacíos retorna HTTP 400
    * def invalido = read('classpath:data/usuarios/registro-invalidos.json').camposVacios
    Given url usuariosBaseUrl
    And path paths.usuarios.register
    And request invalido
    When method post
    Then status 400

  @negative
  Scenario: Contraseña menor a 8 caracteres retorna HTTP 400
    * def invalido = read('classpath:data/usuarios/registro-invalidos.json').passwordCorta
    Given url usuariosBaseUrl
    And path paths.usuarios.register
    And request invalido
    When method post
    Then status 400

  @smoke
  Scenario: Registro exitoso — login confirma que la contraseña fue hasheada
    * def timestamp = function(){ return '' + Date.now() }
    * def email = 'qa.test+' + timestamp() + '@example.com'
    * def registroPayload = read('classpath:data/usuarios/registro.json')
    * set registroPayload.email = email
    Given url usuariosBaseUrl
    And path paths.usuarios.register
    And request registroPayload
    When method post
    Then status 201
    * def loginPayload = read('classpath:data/usuarios/login.json')
    * set loginPayload.email = email
    Given url usuariosBaseUrl
    And path paths.usuarios.login
    And request loginPayload
    When method post
    Then status 200
    And match response.accessToken == '#string'
