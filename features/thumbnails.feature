Feature: Thumbnails get generated for files
  Scenario: Thumbnails get built
    Given a successfully built app at "thumbnails"
    When I cd to "build"
    Then the following files should exist:
      | images/background.png |
      | images/middleman.png |
      | images/background-medium-x300.png |
      | images/background-small-200x.png |
      | images/middleman.png |
      | images/middleman-medium-x300.png |
      | images/middleman-small-200x.png |

  Scenario: Image dimensions are correct
    Given a successfully built app at "thumbnails"
    When I cd to "build"
    Then the image "images/background-medium-x300.png" should have width of "300"
    Then the image "images/background-small-200x.png" should have height of "200"

    # And the file "index.html" should contain 'src="../javascripts/application-df677242.js"'
