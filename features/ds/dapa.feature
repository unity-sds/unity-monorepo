Feature: The DAPA API is a set of function on the data. for the U-DS service
  area, this includes the listing of colleciton,s granules, and the filtering of
  granules by time

  # Acces the {root}/collections endpoint
  Scenario: List Collections
    Given a DAPA endpoint with multiple collections defined
    And the caller has set authentication
    When a request is made to the DAPA Collections endpoint
    Then the response is a STAC document
    And the response returns an HTTP 200
    And the response includes one or more collections
    And each collection has a collection Identifier


  # Access the {root}/collections/{collectionId}/items
  Scenario: List products by Collection
    Given a DAPA endpoint with a colleciton defined
    And the collection has one or more products associated with it
    And the caller has set authentication
    When a request is made to the DAPA items endpoint for the specified collection
    Then the response is a STAC document
    And the response returns an HTTP 200
    And the response includes one or more granules
    And each granule has a temporal extent
    And each granule has one or more data access links

  # Access {root}/collections/{collectionId}/items?datetime=BeginningDate/EndingDate
  Scenario: Filter products by Collection and Time
    Given a DAPA endpoint with a colleciton defined
    And the collection has one or more products associated with it
    And the caller has set authentication
    When a request is made to the DAPA items endpoint for the specified collection and temporal range
    Then the response is a STAC document
    And the response returns an HTTP 200
    And the response includes one or more granules
    And each granule has a temporal extent
    And each granule has one or more data access links
    And no granuels listed are outside the range of the temporal extent specified

  # For the enar term, we should identify the access method as S3 access
  Scenario: Download product via S3
    Given a STAC Response Document specifying collection products with S3 links
    And the caller has set up S3 authentication
    When a user attempts to access a product data access link
    Then the response returns an HTTP 200
    And the object requested is succssfully downloaded
