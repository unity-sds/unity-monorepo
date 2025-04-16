# Tested Requirements: MDPS_2_REQ-30, MDPS_2_REQ-31, MDPS_2_REQ-33, MDPS_2_REQ-34, MDPS_2_REQ-35, MDPS_2_REQ-37

Feature: MDPS_2_REQ-34, MDPS_2_REQ-30, MDPS_2_REQ-31, MDPS_2_REQ-35
  The DAPA API is a set of function on the data. for the U-DS service
  area, this includes the listing of colleciton,s granules, the filtering of
  granules by time, and searching on project provided metadata

  # Access the {root}/collections endpoint
  @shared
  @MDPS_2_REQ-30
  @MDPS_2_REQ-35
  Scenario Outline: List Collections
    Given I have a token to authenticate with Unity Services
    When I make a list collections request to the DAPA endpoint at <endpoint>
    # Then a valid STAC document is returned
    # And the response includes one or more collections
    Then the response includes one or more collections
    And each collection has a collection identifier

    @test
    Examples: endpoints
    | endpoint | venue |
    | https://api.test.mdps.mcp.nasa.gov | test |

  # Access the {root}/collections/{collectionId}/items
  # @shared
  # @MDPS_2_REQ-30
  # @MDPS_2_REQ-31
  Scenario Outline: List products by Collection
    Given I have a token to authenticate with Unity Services
    When I make a get items request to the DAPA endpoint at <endpoint> for <collection_name> with filter <filter>
    Then a valid STAC document is returned
    And the response includes one or more granules
    And each granule has a temporal extent
    And each granule has one or more data access links

    @test
    Examples: endpoints
      | endpoint | collection_name | filter | venue |
      | https://api.test.mdps.mcp.nasa.gov | urn:nasa:unity:unity:test:SBG-L2A_CORFL___1 | updated >= '2024-03-18T00:00:00Z' and updated <= '2024-03-21T23:59:59Z' | test |

  # Access {root}/collections/{collectionId}/items?datetime=BeginningDate/EndingDate
  # @shared
  # @MDPS_2_REQ-34
  # @MDPS_2_REQ-35
  Scenario Outline: Filter products by Collection and Time
    Given I have a token to authenticate with Unity Services
    When I make a datetime filtered get items request to the DAPA endpoint at <endpoint> for <collection_name> with <beginning_date> and <ending_date>
    Then a valid STAC document is returned
    And the response includes one or more granules
    And each granule has one or more data access links
    And each granule is within the range of <beginning_date> and <ending_date>

    @test
    Examples: endpoints
      | endpoint | collection_name | beginning_date | ending_date | venue |
      | https://api.test.mdps.mcp.nasa.gov | urn:nasa:unity:unity:test:SBG-L2A_CORFL___1 | 2024-03-18T00:00:00Z | 2024-03-21T23:59:59Z | test |

  # @shared
  # @MDPS_2_REQ-35
  # Scenario: Search on custom, project provided metadata
    # Given a DAPA endpoint with a colleciton defined
    # And the caller has set authentication
    # And the collection has one or more products associated with it
    # When a request is made to the DAPA items endpoint for the specified metadata
    # Then the response is a STAC document
    # And the response returns an HTTP 200
    # And the response includes one or more collections
    # And each collection has a collection Identifier


  # For the near term, we should identify the access method as S3 access
  # Scenario: Download product via S3
    # Given a STAC Response Document specifying collection products with S3 links
    # And the caller has set up S3 authentication
    # When a user attempts to access a product data access link
    # Then the response returns an HTTP 200
    # And the object requested is successfully downloaded
