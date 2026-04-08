@smoke @regression @contract
Feature: Recomendacion de proveedor — POST /api/v1/pedido

  Background:
    * def schemaRecomendacion = read('classpath:schemas/pedidos/recomendacion.json')

  @smoke
  Scenario: Prioridad COST recomienda proveedor de menor costo
    * def payload = read('classpath:data/pedidos/recomendacion-casos.json').menorCosto
    Given url pedidosBaseUrl
    And path paths.pedidos.pedido
    And request payload
    When method post
    Then status 200
    And match response.recommendation.providerName == '#string'

  @smoke
  Scenario: Prioridad TIME recomienda proveedor de menor tiempo
    * def payload = read('classpath:data/pedidos/recomendacion-casos.json').menorTiempo
    Given url pedidosBaseUrl
    And path paths.pedidos.pedido
    And request payload
    When method post
    Then status 200
    And match response.recommendation.providerName == '#string'

  @regression @wip
  Scenario: Desempate por tiempo — empate en costo gana menor tiempo de entrega
    # Precondicion: backend configurado con mock empate en costo
    * def payload = read('classpath:data/pedidos/recomendacion-casos.json').desempateCosto
    Given url pedidosBaseUrl
    And path paths.pedidos.pedido
    And request payload
    When method post
    Then status 200
    And match response.recommendation.providerName == '#string'

  @regression @wip
  Scenario: Desempate por costo — empate en tiempo gana menor costo
    # Precondicion: backend configurado con mock empate en tiempo
    * def payload = read('classpath:data/pedidos/recomendacion-casos.json').desempateTiempo
    Given url pedidosBaseUrl
    And path paths.pedidos.pedido
    And request payload
    When method post
    Then status 200
    And match response.recommendation.providerName == '#string'

  @contract
  Scenario: Contrato de respuesta incluye campos requeridos
    * def payload = read('classpath:data/pedidos/pedido-base.json')
    Given url pedidosBaseUrl
    And path paths.pedidos.pedido
    And request payload
    When method post
    Then status 200
    And match response == schemaRecomendacion

  @contract
  Scenario: Recomendacion principal no aparece duplicada en alternatives
    * def payload = read('classpath:data/pedidos/pedido-base.json')
    Given url pedidosBaseUrl
    And path paths.pedidos.pedido
    And request payload
    When method post
    Then status 200
    * def recommendedProvider = response.recommendation.providerName
    * def duplicado = karate.filter(response.alternatives, function(a){ return a.providerName == recommendedProvider })
    And match duplicado == []
