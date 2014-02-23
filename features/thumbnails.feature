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

  Scenario: Thumbnail dimensions are correct
    Given a successfully built app at "thumbnails"
    When I cd to "build"
    Then the image "images/background-medium-x300.png" should have width of "300"
    Then the image "images/background-small-200x.png" should have height of "200"

  Scenario: Thumbnails are regenerated when files have changed
    Given a successfully built app at "thumbnails"
    Then I should be able to update an image "images/middleman.png" and the thumbnails regenerate

  Scenario: Thumbnails do not regenerate when source files have not changed
    Given a successfully built app at "thumbnails"
    Then I should be able to rebuild "images/middleman.png" and the thumbnails do not regenerate