Feature: Ensure granules can be found by their parent collections

  Scenario Outline: An existing collection is queried to ensure granules can be found using it
    Given I authenticate with Unity Services
    When I make a get_collection_data call for <collection_name>
    Then the response includes one or more granules

    @develop
    Examples: collections
      | collection_name  | venue |
      | urn:nasa:unity:ssips:TEST1:CHRP_16_DAY_REBIN___1 | dev |


    @test
    Examples: collections
      | collection_name   | venue |
      | urn:nasa:unity:ssips:TEST1:CHRP_16_DAY_REBIN___1 | test |
