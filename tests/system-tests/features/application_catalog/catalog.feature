Feature: Algorithm catalog system tests

  Scenario Outline: Algorithm Packages can be registered in the catalog
    Given I have an {algorithm binary} in {repository}
    And I have an {algorithm descriptor} in {repository}
    When the algorithm descriptor is registered in the algorithm catalog
    Then the algorithm can be found in the algorithm catalog
    And the search result maps back to the {algorithm binary}

    @test
    Examples: algorithms
    | repository | algorithm descriptor | algorithm binary |
    | TBD | TBD | TBD |

  Scenario Outline: Search the catalog for algorithm packages using a filter
  # This needs to identify these algorithms by a unique but shared criteria (tag?)
  # but it would be difficult to identify them by names - a count would be an
  # effective measure.
  #
  # Given a set of catalog algorithms
  # | name      | binary              |
  # | algo1     | https://algo1.com   |
  # | algo2     | https://algo2.com   |
  # | algo3     | https://algo3.com   |
  # And the catalog algorithms are registered in the algorithm catalog
  # When a user searches the algorithm catalog
  # Then the search retrieves 3 results
    Given a set of catalog algorithms are registered in the algorithm catalog having {tag} of {value}
    When I search the algorithm catalog for catalog algorithms having {tag} of {values}
    Then the search results identifies {result_size} algorithms
 
    @test
    Examples: tags
    | tag | value | result_size |
    | TBD | TBD | TBD |

  Scenario Outline: Access an algorithm package from a catalog result
  # Given a set of catalog algorthms
  # | name      | binary              |
  # | algo1     | https://algo1.com   |
  # | algo2     | https://algo2.com   |
  # | algo3     | https://algo3.com   |
  # And the catalog algorithms are registered in the algorithm catalog
  # When a user searches the algorithm catalog by name
  # Then the user gets the algorithm package back
  # And the algorithm package references the correct binary
  # And the binary is accessible
  Given I have a catalog algorithm named {algorithm_name} registered in the algorithm catalog
  When I search the algorithm catalog by {algorithm_name}
  Then the results reference the binary {algorithm_binary}
  And the binary {algorithm_binary} is accessible

  @test
  | algorithm_name | algorithm_binary |
  | TBD | TBD |
