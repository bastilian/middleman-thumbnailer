@announce-stdout
Feature: Thumbnails get generated for files
  Scenario: Thumbnails get built
    Given a successfully built app at "thumbnails"
    When I cd to "build"
    Then the following files should exist:
      | images/background.png |
      | images/middleman.png |
      | images/background-medium-400x300.png |
      | images/background-small-200x.png |
      | images/middleman.png |
      | images/middleman-medium-400x300.png |
      | images/middleman-small-200x.png |

    # And the file "index.html" should contain 'src="../javascripts/application-df677242.js"'
