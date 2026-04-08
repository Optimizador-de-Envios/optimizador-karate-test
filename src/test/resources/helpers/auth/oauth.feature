Feature: Obtener token OAuth para Karate

  Scenario:
    Given url tokenUrl
    And form field grant_type = 'client_credentials'
    And form field client_id = clientId
    And form field client_secret = clientSecret
    When method post
    Then status 200
    And match response.access_token == '#string'
    * def token = response.access_token
