@ignore
Feature: Helper — Registro y login de usuario QA para obtener JWT

  Scenario:
    * def timestamp = function(){ return '' + Date.now() }
    * def email = 'qa.test+' + timestamp() + '@example.com'

    * def registerPayload = read('classpath:data/usuarios/registro.json')
    * set registerPayload.email = email

    Given url usuariosBaseUrl
    And path paths.usuarios.register
    And request registerPayload
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

    * def authToken = 'Bearer ' + response.accessToken
