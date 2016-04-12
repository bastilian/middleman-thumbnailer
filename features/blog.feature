Feature: Blog
  Scenario:  Thumbnails get built
    Given a successfully built app at "blog"
    When I cd to "build"
    Then the following files should exist:
      | blog/2016-01-middleman/middleman-medium-x300.png |
      | blog/2016-01-middleman/middleman-small-200x.png |
