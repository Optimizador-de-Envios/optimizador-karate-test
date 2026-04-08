@smoke @regression @negative
Feature: Registro de pedido — validaciones de entrada — POST /api/v1/pedido

  @negative
  Scenario: Origen, destino y peso vacios retorna HTTP 400
    * def invalido = read('classpath:data/pedidos/pedidos-invalidos.json').camposVacios
    Given url pedidosBaseUrl
    And path paths.pedidos.pedido
    And request invalido
    When method post
    Then status 400

  @negative @wip
  Scenario: Origen fuera de Colombia retorna HTTP 400
    * def invalido = read('classpath:data/pedidos/pedidos-invalidos.json').origenFuera
    Given url pedidosBaseUrl
    And path paths.pedidos.pedido
    And request invalido
    When method post
    Then status 400

  @negative @wip
  Scenario: Destino fuera de Colombia retorna HTTP 400
    * def invalido = read('classpath:data/pedidos/pedidos-invalidos.json').destinoFuera
    Given url pedidosBaseUrl
    And path paths.pedidos.pedido
    And request invalido
    When method post
    Then status 400

  @negative
  Scenario: Peso inferior al minimo (0.0009 Kg) retorna HTTP 400
    * def invalido = read('classpath:data/pedidos/pedidos-invalidos.json').pesoMenorMinimo
    Given url pedidosBaseUrl
    And path paths.pedidos.pedido
    And request invalido
    When method post
    Then status 400

  @negative
  Scenario: Peso superior al maximo (70.001 Kg) retorna HTTP 400
    * def invalido = read('classpath:data/pedidos/pedidos-invalidos.json').pesoMayorMaximo
    Given url pedidosBaseUrl
    And path paths.pedidos.pedido
    And request invalido
    When method post
    Then status 400

  @negative
  Scenario: Sin campo prioridad retorna HTTP 400
    * def invalido = read('classpath:data/pedidos/pedidos-invalidos.json').sinPrioridad
    Given url pedidosBaseUrl
    And path paths.pedidos.pedido
    And request invalido
    When method post
    Then status 400

  @smoke
  Scenario: Peso limite minimo (0.001 Kg) es aceptado — HTTP 200
    * def payload = read('classpath:data/pedidos/pedido-limite-minimo.json')
    Given url pedidosBaseUrl
    And path paths.pedidos.pedido
    And request payload
    When method post
    Then status 200

  @smoke
  Scenario: Peso limite maximo (70 Kg) es aceptado — HTTP 200
    * def payload = read('classpath:data/pedidos/pedido-limite-maximo.json')
    Given url pedidosBaseUrl
    And path paths.pedidos.pedido
    And request payload
    When method post
    Then status 200
