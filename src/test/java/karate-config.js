function fn() {
  var env = karate.env || 'qa';

  var config = {
    env: env,
    baseUrl: karate.properties[env + '.baseUrl']
      || karate.properties['qa.baseUrl']
      || karate.properties['baseUrl']
      || 'http://localhost:8080',
    usuariosBaseUrl: karate.properties['usuarios.baseUrl'] || 'http://localhost:8081',
    pedidosBaseUrl:  karate.properties['pedidos.baseUrl']  || 'http://localhost:8080',
    rutasBaseUrl:    karate.properties['rutas.baseUrl']    || 'http://localhost:8080',
    auth: {
      type: karate.properties['auth.type'] || 'login',
      token: karate.properties['auth.token'],
      tokenUrl: karate.properties['auth.tokenUrl'],
      clientId: karate.properties['auth.clientId'],
      clientSecret: karate.properties['auth.clientSecret'],
      username: karate.properties['auth.username'],
      password: karate.properties['auth.password'],
      loginPath: karate.properties['auth.loginPath']
    },
    paths: {
      usuarios: {
        register: '/api/users/register',
        login:    '/api/users/login'
      },
      pedidos: {
        pedido:     '/api/v1/pedido',
        confirmar:  '/api/v1/pedido/confirmar',
        misPedidos: '/api/v1/pedido/mis-pedidos'
      }
    }
  };

  karate.configure('connectTimeout', 15000);
  karate.configure('readTimeout', 15000);

  return config;
}
