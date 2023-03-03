function fn(auth) {
    var credentials = karate.merge(auth || {});
    
    if (credentials == null || credentials === 'none' || credentials === undefined) {
        return null;
        karate.log('Trying to authenticate with auth mode. Aborting. credentials:', credentials);
        karate.abort();
    }

    // returns basic authorization header based on basic auth
    var basicAuth = function(credentials) {
        var temp = credentials.username + ':' + credentials.password;
        let Base64 = Java.type('java.util.Base64');
        let encoded = Base64.getEncoder().encodeToString(
            temp.toString().getBytes());
        return { Authorization: 'Basic ' + encoded };
    };

    // returns mocked token oauth authorization header
    var token = function() {
        return { Authorization: 'Bearer f4a14088-23af-466a-a6e3-457e591d7811' };
    };

    // returns invalid mocked token oauth authorization header
    var invalidToken = function() {
        return { Authorization: 'Bearer 1' };
    };

    // returns not existing mocked token oauth authorization header
    var notExistingToken = function() {
        return { Authorization: 'Bearer zzzzzzz-23af-466a-a6e3-457e591d7811' };
    };

    // returns expired mocked token oauth authorization header
    var expiredToken = function() {
        return { Authorization: 'Bearer expired-23af-466a-a6e3-457e591d7811' };
    };

    // returns mocked token oauth authorization header for mobile client
    var mobileClientToken = function() {
        return { Authorization: 'Bearer mobile23af-466a-a6e3-457e591d7811' };
    };

    var authModes = {
        'basic': basicAuth,
        'oauth2_valid_token': token,
        'oauth2_valid_expired_token': expiredToken,
        'oauth2_valid_mobile_token': mobileClientToken,
        'oauth2_valid_not_existing_token': notExistingToken,
        'oauth2_valid_invalid_token': invalidToken
    };

    var authModeFunction = authModes[credentials];

    // calls auth function and return auth header
    return authModeFunction ? authModeFunction(credentials) : null;
}
