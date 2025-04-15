Feature: MDPS_2_REQ-33
  The data catalog shall return search results in STAC (SpatioTemporal Asset Catalogs) format

  # Positive test for the get_collection_data() endpoint
  @shared
  @data-catalog
  @integration-test
  @testrail-C4454761
  Scenario Outline: Confirm results from data catalog:get_collection_data()
    Given I have a token to authenticate with Unity Services
    When I query <collection_name> from the data catalog with <filter>
    Then a valid STAC document is returned

    @test
    Examples: collections
      | collection_name | filter | venue |
      | urn:nasa:unity:unity:test:SBG-L2A_CORFL___1 | updated >= '2024-03-18T00:00:00Z' and updated <= '2024-03-21T23:59:59Z' | test |


  # Access the {root}/collections/collection/items endpoint
  # @shared
  # @data-catalog
  # Scenario Outline: Confirm STAC-results from data catalog:get_items()
    # Given I have a token to authenticate with Unity Services
    # And a collection in the unity <endpoint>
    # When a request is made to the DAPA endpoint at <endpoint>
    # Then a valid STAC document is returned

    # @develop
    # Examples: endpoints
      # | endpoint  |
      # | https://github.com/unity-sds/unity-example-application.git |

    # @test
    # Examples: endpoints
      # | endpoint  |
      # | https://github.com/unity-sds/unity-example-application.git |
