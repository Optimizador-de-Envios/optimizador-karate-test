Feature: Resolver autenticacion del proyecto

  Scenario:
    * def currentAuth = auth
    * if (!currentAuth || !currentAuth.type) karate.fail('auth.type no configurado')
    * def resolveToken =
    """
    function(currentAuth, baseUrl) {
      if (currentAuth.type === 'bearer') {
        if (!currentAuth.token) karate.fail('auth.token es obligatorio para bearer');
        return { token: currentAuth.token };
      }
      if (currentAuth.type === 'oauth') {
        return karate.call('classpath:helpers/auth/oauth.feature', currentAuth);
      }
      if (currentAuth.type === 'login') {
        return karate.call('classpath:helpers/auth/login.feature', {
          baseUrl: baseUrl,
          loginPath: currentAuth.loginPath,
          username: currentAuth.username,
          password: currentAuth.password
        });
      }
      karate.fail('auth.type no soportado: ' + currentAuth.type);
    }
    """
    * def result = resolveToken(currentAuth, baseUrl)
    * match result.token == '#string'
