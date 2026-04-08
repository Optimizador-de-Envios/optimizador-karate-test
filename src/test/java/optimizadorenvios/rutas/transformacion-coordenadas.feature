@regression @contract @wip
Feature: Transformación de coordenadas ORS → Leaflet — POST /api/v1/pedido

  Background:
    * def authResult = callonce read('classpath:helpers/auth/register-login.feature')
    * def authToken = authResult.authToken
    * def datos = read('classpath:data/rutas/coordenadas-ors.json')

  @regression @contract
  Scenario: Coordenadas ORS [lng, lat] son invertidas a [lat, lng] en la respuesta del backend
    * def payload = datos.pedido
    Given url rutasBaseUrl
    And path paths.pedidos.pedido
    And header Authorization = authToken
    And request payload
    When method post
    Then status 201
    * def ruta = response.ruta
    * def primeraCoord = ruta[0]
    # ORS retorna [-74.0721, 4.7110] (lng, lat); el backend debe transformar a [4.7110, -74.0721] (lat, lng)
    And match primeraCoord[0] == datos.coordenadaEsperada.lat
    And match primeraCoord[1] == datos.coordenadaEsperada.lng
