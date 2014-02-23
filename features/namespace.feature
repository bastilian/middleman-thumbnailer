Feature: Namespacing 
  Scenario: Thumbnailing gets correctly namespaced
    Given a successfully built app at "namespace"
    When I cd to "build"
    Then the following files should exist:
      | images/background.png |
      | images/middleman.png |
      | images/test/background-medium-x300.png | 
      | images/test/background-small-200x.png |

    Then the following files should not exist:
      | images/background-medium-x300.png |
      | images/background-small-200x.png |
      | images/middleman-medium-x300.png |
      | images/middleman-small-200x.png |