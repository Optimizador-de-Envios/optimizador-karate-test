Feature: Obtener token por login para Karate

  Scenario:
    Given url baseUrl
    And path loginPath
    And request { username: '#(username)', password: '#(password)' }
    When method post
    Then status 200
    And match response.token == '#string'
    * def token = response.token
