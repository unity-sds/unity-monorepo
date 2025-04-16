Feature: MDPS_2_REQ-33
  The data catalog shall return search results in STAC (SpatioTemporal Asset Catalogs) format

  # Positive test for the get_collection_data() endpoint
  @shared
  @data-catalog
  @integration-test
  @testrail-C4454761
  Scenario Outline: Confirm results from data catalog:get_collection_data()
    Given I have a token to authenticate with Unity Services
    When I make a get_collection_data call for <collection_name> with <filter>
    Then a valid STAC document is returned

    @test
    Examples: collections
      | collection_name | filter | venue |
      | urn:nasa:unity:unity:test:SBG-L2A_CORFL___1 | updated >= '2024-03-18T00:00:00Z' and updated <= '2024-03-21T23:59:59Z' | test |


  # Access the {root}/collections/<collection_name>/items endpoint
  @shared
  @data-catalog
  Scenario Outline: Confirm STAC-results from data catalog:get_items()
    Given I have a token to authenticate with Unity Services
    When I make a get items request to the DAPA endpoint at <endpoint> for <collection_name> with filter <filter>
    Then a valid STAC document is returned

    @test
    Examples: endpoints
      | endpoint | collection_name | filter | venue |
      | https://api.test.mdps.mcp.nasa.gov | urn:nasa:unity:unity:test:SBG-L2A_CORFL___1 | updated >= '2024-03-18T00:00:00Z' and updated <= '2024-03-21T23:59:59Z' | test |
