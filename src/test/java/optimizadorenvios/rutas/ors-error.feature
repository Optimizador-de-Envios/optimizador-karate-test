@regression @negative @wip
Feature: Manejo de error de OpenRouteService — POST /api/v1/pedido

  Background:
    * def authResult = callonce read('classpath:helpers/auth/register-login.feature')
    * def authToken = authResult.authToken
    * def datos = read('classpath:data/rutas/ors-error-stub.json')

  @negative
  Scenario: ORS devuelve features vacío — el backend responde de forma controlada
    # Precondición: stub ORS configurado para responder { "features": [] }
    * def payload = datos.pedido
    Given url rutasBaseUrl
    And path paths.pedidos.pedido
    And header Authorization = authToken
    And request payload
    When method post
    Then match responseStatus != 500
    And match response != null

  @negative
  Scenario: ORS devuelve HTTP 500 — el flujo de cotización no falla completamente
    # Precondición: stub ORS configurado para responder HTTP 500
    * def payload = datos.pedido
    Given url rutasBaseUrl
    And path paths.pedidos.pedido
    And header Authorization = authToken
    And request payload
    When method post
    Then match responseStatus != 500
    And match response != null
