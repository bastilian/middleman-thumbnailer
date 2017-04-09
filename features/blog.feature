Feature: Blog
  Scenario:  Thumbnails get built
    Given a fixture app "site"
    And app "site" is using config "basic"
    And a successfully built app at "site"
    Then the following files should exist:
      | build/blog/2016-01-middleman/middleman-medium-x300.png |
      | build/blog/2016-01-middleman/middleman-small-200x.png |
