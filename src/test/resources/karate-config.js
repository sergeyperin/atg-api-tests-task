function fn() {
  function read(file) {
    try {
      return karate.read(file);
    } catch (e) {
      karate.log("File not found: " + file)
      return {};
    }
  }

  karate.configure('connectTimeout', 30000);
  karate.configure('readTimeout', 30000);
  karate.set(read('classpath:config.yml'));
  karate.set(read(`classpath:config-${karate.env}.yml`));
  if ( karate.env != 'local') {
    karate.set(read(`classpath:config-${karate.env}-secret.yml`));
  }
  return { 
    utils: karate.call('classpath:karate-utils.js'),
  }
}
