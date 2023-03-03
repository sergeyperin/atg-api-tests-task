Feature: Get pet in pet store

  Background:
    * url urls.petStoreApiUrl
    * def getId =
  """
  function() {
    return java.lang.System.nanoTime()
  }
  """
    * def id_pet = getId()
    * def id_category_pet = getId()
    * def tag_id = getId()
    * def pet_category_name = 'dogs'
    * def pet_name = 'Pluto'
    * def photo_url = 'https://upload.wikimedia.org/wikipedia/en/b/b2/Pluto_%28Disney%29_transparent.png'
    * def status = 'available'
    * def tag_name1 = 'disney'
    * def tag_name2 = 'lovely'
     # preparation
    * def auth = 'oauth2_valid_token'
    * def authHeader = call read('classpath:karate-auth.js') auth
    * def body = karate.readAsString('classpath:features/pet/create/test-data/create_pet_schema.json')
    # actions
    Given path '/pet'
    And replace body.pet_id = id_pet
    And replace body.pet_category_name = pet_category_name
    And replace body.pet_category_id = id_category_pet
    And replace body.pet_name = pet_name
    And replace body.photo_url = photo_url
    And replace body.status = status
    And replace body.tag_id = tag_id
    And replace body.tag_name1 = tag_name1
    And replace body.tag_name2 = tag_name2
    And header Content-Type = 'application/json'
    And headers authHeader
    And request body
    When method POST
    # verification
    Then status 200
    * def created_pet_id = response.id

  Scenario: get pet happy path
    # preparation
    * def auth = 'oauth2_valid_token'
    * def authHeader = call read('classpath:karate-auth.js') auth
    # actions
    Given path '/pet/' + created_pet_id
    And header Content-Type = 'application/json'
    And headers authHeader
    When method GET
    # verification
    Then status 200
    * match response contains {id:'#notnull', category: '#object', name:'#notnull', photoUrls:'#array', tags:'#[2]', status: '##string'}
    * match response.id == '#(created_pet_id)'
    * match response.category.name == '#(pet_category_name)'
    * match response.category.id == '#(id_category_pet)'
    * match response.name == '#(pet_name)'
    * match response.status == '#(status)'

  Scenario: get not existing pet 404 error
    # preparation
    * def auth = 'oauth2_valid_token'
    * def authHeader = call read('classpath:karate-auth.js') auth
    * def absent_id_pet = getId()
    # actions
    Given path '/pet/' + absent_id_pet
    And header Content-Type = 'application/json'
    And headers authHeader
    When method GET
    # verification
    Then status 404
    * match response contains {code:'#number', type: '#string', message:'#string'}
    * match response.type == 'error'
    * match response.message == 'Pet not found'

  Scenario: get pet by string id
    # preparation
    * def auth = 'oauth2_valid_token'
    * def authHeader = call read('classpath:karate-auth.js') auth
    * def absent_id_pet = getId()
    # actions
    Given path '/pet/' + 'pet'
    And header Content-Type = 'application/json'
    And headers authHeader
    When method GET
    # verification
    Then status 404
    * match response contains {code:'#number', type: '#string', message:'#string'}
    * match response.type == 'unknown'
    * match response.message contains 'NumberFormatException'

  Scenario: get pet by empty id
    # preparation
    * def auth = 'oauth2_valid_token'
    * def authHeader = call read('classpath:karate-auth.js') auth
    * def absent_id_pet = getId()
    # actions
    Given path '/pet/' + ''
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And headers authHeader
    When method GET
    # verification
    Then status 405
    * match response contains {code:'#number', type: '#string'}
    * match response.code == 405
    * match response.type == 'unknown'






