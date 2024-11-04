Feature: MDPS_2_REQ-33
  The data catalog shall return search results in STAC (SpatioTemporal Asset Catalogs) format

  # Positive test for the get_collection_data() endpoint
  @shared
  @data-catalog
  @integration-test
  @testrail-C4454761
  Scenario: Confirm results from data catalog:get_collection_data()
    Given I have a token to authenticate with Unity Services
    When a collection lookup request is made to the DAPA endpoint 
    Then one and only one collection is returned

#  #Access the {root}/collections/collection/items endpoint
#  @shared
#  @data-catalog
#  Scenario Outline: Confirm STAC-results from data catalog:get_items
#    Given an authenticated Unity user
#    And a collection in the unity <endpoint>
#    When a request is made to the DAPA endpoint at <endpoint>
#    Then the response is a STAC document
#
#    @develop
#    Examples: endpoints
#      | endpoint  |
#      | https://github.com/unity-sds/unity-example-application.git |
#
#    @test
#    Examples: endpoints
#      | endpoint  |
#      | https://github.com/unity-sds/unity-example-application.git |
