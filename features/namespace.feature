Feature: Namespacing
  Scenario: Thumbnailing gets correctly namespaced
    Given a fixture app "namespace"
    When I run `middleman build`
    Then the following files should exist:
      | build/images/background.png |
      | build/images/middleman.png |
      | build/images/test/background-medium-x300.png |
      | build/images/test/background-small-200x.png |

    Then the following files should not exist:
      | build/images/background-medium-x300.png |
      | build/images/background-small-200x.png |
      | build/images/middleman-medium-x300.png |
      | build/images/middleman-small-200x.png |
