@smoke @regression @negative @auth
Feature: Login de usuario — POST /api/users/login

  Background:
    * def authResult = callonce read('classpath:helpers/auth/register-login.feature')
    * def schemaLogin = read('classpath:schemas/usuarios/login-response.json')

  @negative
  Scenario: Credenciales inválidas retorna HTTP 401
    * def invalido = read('classpath:data/usuarios/login-invalidos.json').credencialesInvalidas
    Given url usuariosBaseUrl
    And path paths.usuarios.login
    And request invalido
    When method post
    Then status 401

  @smoke @auth
  Scenario: Login exitoso retorna token JWT
    * def loginPayload = read('classpath:data/usuarios/login.json')
    * set loginPayload.email = authResult.email
    Given url usuariosBaseUrl
    And path paths.usuarios.login
    And request loginPayload
    When method post
    Then status 200
    And match response == schemaLogin
