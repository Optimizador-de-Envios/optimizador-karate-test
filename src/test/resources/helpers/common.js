function fn() {
  return {
    toBearer: function(token) {
      return 'Bearer ' + token;
    },
    notBlank: function(value) {
      return value !== null && value !== undefined && value !== '';
    }
  };
}
