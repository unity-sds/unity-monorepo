# Tested Requirements: MDPS_2_REQ-30, MDPS_2_REQ-31, MDPS_2_REQ-33, MDPS_2_REQ-34, MDPS_2_REQ-35, MDPS_2_REQ-37

Feature: MDPS_2_REQ-34, MDPS_2_REQ-30, MDPS_2_REQ-31, MDPS_2_REQ-35
  The DAPA API is a set of function on the data. for the U-DS service
  area, this includes the listing of collections, granules, the filtering of
  granules by time, and searching on project provided metadata

  # Access the {root}/collections endpoint
  @shared
  @MDPS_2_REQ-30
  @MDPS_2_REQ-35
  Scenario Outline: List Collections
    Given I authenticate with Unity Services
    When I make a list collections request to the DAPA endpoint at <endpoint>
    Then the response includes one or more collections
    And the response specifies a set of valid STAC collections
    And each collection in the response has a collection identifier

    @test
    Examples: endpoints
    | endpoint | venue |
    | https://api.test.mdps.mcp.nasa.gov | test |

  # Access the {root}/collections/{collectionId}/items
  # @shared
  # @MDPS_2_REQ-30
  # @MDPS_2_REQ-31
  Scenario Outline: List products by Collection
    Given I authenticate with Unity Services
    When I make a get items request to the DAPA endpoint at <endpoint> for <collection_name> with filter <filter>
    Then the response includes one or more granules
    And the response specifies a set of valid STAC collection items
    And each granule in the response has a temporal extent
    And each granule in the response has one or more data access links

    @test
    Examples: endpoints
      | endpoint | collection_name | filter | venue |
      | https://api.test.mdps.mcp.nasa.gov | urn:nasa:unity:unity:test:SBG-L2A_CORFL___1 | updated >= '2024-03-18T00:00:00Z' and updated <= '2024-03-21T23:59:59Z' | test |

  # Access {root}/collections/{collectionId}/items?datetime=BeginningDate/EndingDate
  # @shared
  # @MDPS_2_REQ-34
  # @MDPS_2_REQ-35
  Scenario Outline: Filter products by Collection and Time
    Given I authenticate with Unity Services
    When I make a datetime filtered get items request to the DAPA endpoint at <endpoint> for <collection_name> with <beginning_date> and <ending_date>
    Then the response includes one or more granules
    And the response specifies a set of valid STAC collection items
    And each granule in the response has one or more data access links
    And each granule in the response is within the range of <beginning_date> and <ending_date>

    @test
    Examples: endpoints
      | endpoint | collection_name | beginning_date | ending_date | venue |
      | https://api.test.mdps.mcp.nasa.gov | urn:nasa:unity:unity:test:SBG-L2A_CORFL___1 | 2024-03-18T00:00:00Z | 2024-03-21T23:59:59Z | test |

  # @shared
  # @MDPS_2_REQ-35
  Scenario Outline: Search on custom, project provided metadata
    Given I authenticate with Unity Services
    When I make a get items request to the DAPA endpoint at <endpoint> for <collection_name>
    Then the response includes one or more granules
    And the response specifies a set of valid STAC collection items
    And each collection in the response has a collection Identifier

    @test
    Examples: endpoints
      | endpoint | collection_name |
      | https://api.test.mdps.mcp.nasa.gov | urn:nasa:unity:unity:test:SBG-L2A_CORFL___1 |

  # For the near term, we should identify the access method as S3 access
  @AWS_test
  Scenario Outline: Download product via S3
    Given I authenticate with Unity Services
    And I authenticate with AWS 
    When I make a get items request to the DAPA endpoint at <endpoint> for <collection_name>
    Then the response specifies a set of valid STAC collection items
    And each granule in the response has one or more data access links
    And the object is downloaded from S3 via the data access link in the response

    @test
    Examples: endpoints
      | endpoint | collection_name |
      | https://api.test.mdps.mcp.nasa.gov | urn:nasa:unity:unity:test:SBG-L2A_CORFL___1 |


    # Given a STAC Response Document specifying collection products with S3 links
    # And the caller has set up S3 authentication
    # When a user attempts to access a product data access link
    # Then the response returns an HTTP 200
    # And the object requested is successfully downloaded
