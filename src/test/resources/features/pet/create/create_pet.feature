Feature: Create pet in pet store

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
    * def localization_value = '体字体字体字体字体字体字'

  Scenario: create pet happy path
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
    * match response contains {id:'#notnull', category: '#object', name:'#notnull', photoUrls:'#array', tags:'#[2]', status: '##string'}
    * match response.id == '#(id_pet)'
    * match response.category.name == '#(pet_category_name)'
    * match response.category.id == '#(id_category_pet)'
    * match response.name == '#(pet_name)'
    * match response.status == '#(status)'


  Scenario: empty string for pet id in request to check id is generated randomly eventually in response
    # preparation
    * def auth = 'oauth2_valid_token'
    * def authHeader = call read('classpath:karate-auth.js') auth
    * def body = karate.readAsString('classpath:features/pet/create/test-data/create_pet_schema.json')
    # actions
    Given path '/pet'
    And replace body.pet_id = ""
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
    * match response contains {id:'#number', category: '#object', name:'#notnull', photoUrls:'#array', tags:'#[2]', status: '##string'}

  Scenario: invalid string value for pet id in request to check 500 error in response
    # preparation
    * def auth = 'oauth2_valid_token'
    * def authHeader = call read('classpath:karate-auth.js') auth
    * def body = karate.readAsString('classpath:features/pet/create/test-data/create_pet_schema.json')
    # actions
    Given path '/pet'
    And replace body.pet_id = "invalid string"
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
    Then status 500
    * match response contains {code:'#number', type: '#string', message:'#string'}

  Scenario: check string with 4 byte symbols size (localization) in request message returns correct response
    # preparation
    * def auth = 'oauth2_valid_token'
    * def authHeader = call read('classpath:karate-auth.js') auth
    * def body = karate.readAsString('classpath:features/pet/create/test-data/create_pet_schema.json')
    # actions
    Given path '/pet'
    And replace body.pet_id = id_pet
    And replace body.pet_category_name = localization_value
    And replace body.pet_category_id = id_category_pet
    And replace body.pet_name = localization_value
    And replace body.photo_url = photo_url
    And replace body.status = localization_value
    And replace body.tag_id = tag_id
    And replace body.tag_name1 = localization_value
    And replace body.tag_name2 = localization_value
    And header Content-Type = 'application/json'
    And headers authHeader
    And request body
    When method POST
    # verification
    Then status 200
    * match response contains {id:'#notnull', category: '#object', name:'#notnull', photoUrls:'#array', tags:'#[2]', status: '##string'}
    * match response.id == '#(id_pet)'
    * match response.category.name == '#(localization_value)'
    * match response.category.id == '#(id_category_pet)'
    * match response.name == '#(localization_value)'
    * match response.status == '#(localization_value)'



