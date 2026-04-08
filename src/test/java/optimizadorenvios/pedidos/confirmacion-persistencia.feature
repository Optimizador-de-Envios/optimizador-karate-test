@smoke @regression @negative @auth
Feature: Confirmacion de proveedor y persistencia — POST /api/v1/pedido/confirmar · GET /api/v1/pedido/mis-pedidos

  Background:
    * def authResult = callonce read('classpath:helpers/auth/register-login.feature')
    * def authToken = authResult.authToken
    * def schemaConfirmacion = read('classpath:schemas/pedidos/confirmar-response.json')

  @negative
  Scenario: Sin selectedOption en confirmacion retorna HTTP 400
    * def sinOpcion = read('classpath:data/pedidos/confirmacion.json').sinSelectedOption
    Given url pedidosBaseUrl
    And path paths.pedidos.confirmar
    And header Authorization = authToken
    And request sinOpcion
    When method post
    Then status 400

  @negative
  Scenario: selectedOption invalida (no calculada) retorna HTTP 400 o 422
    * def pedidoPayload = read('classpath:data/pedidos/pedido-base.json')
    Given url pedidosBaseUrl
    And path paths.pedidos.pedido
    And request pedidoPayload
    When method post
    Then status 200
    * def confirmInvalido = read('classpath:data/pedidos/confirmacion.json').proveedorInvalido
    * set confirmInvalido.order = pedidoPayload.order
    Given url pedidosBaseUrl
    And path paths.pedidos.confirmar
    And header Authorization = authToken
    And request confirmInvalido
    When method post
    Then match responseStatus == 400 || responseStatus == 422

  @smoke @auth
  Scenario: Confirmacion exitosa — pedido queda persistido en mis-pedidos
    * def pedidoPayload = read('classpath:data/pedidos/pedido-base.json')
    Given url pedidosBaseUrl
    And path paths.pedidos.pedido
    And request pedidoPayload
    When method post
    Then status 200
    * def recomendacion = response.recommendation
    * def confirmToken = 'confirm-' + java.lang.System.currentTimeMillis()
    * def confirmPayload = { confirmationToken: '#(confirmToken)', order: '#(pedidoPayload.order)', selectedOption: { providerName: '#(recomendacion.providerName)', cost: '#(recomendacion.cost)', currency: '#(recomendacion.currency)', estimatedDays: '#(recomendacion.estimatedDays)' } }
    Given url pedidosBaseUrl
    And path paths.pedidos.confirmar
    And header Authorization = authToken
    And request confirmPayload
    When method post
    Then status 201
    And match response == schemaConfirmacion
    * def confirmedId = response.id
    Given url pedidosBaseUrl
    And path paths.pedidos.misPedidos
    And header Authorization = authToken
    When method get
    Then status 200
    * def encontrado = karate.filter(response, function(p){ return p.id == confirmedId })
    And match encontrado[0].id == confirmedId
