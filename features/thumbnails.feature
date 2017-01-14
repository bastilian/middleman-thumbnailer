Feature: Thumbnails get generated for files
  Scenario: Thumbnails get built
    Given a successfully built app at "thumbnails"
    Then the following files should exist:
      | build/images/background.png |
      | build/images/middleman.png |
      | build/images/background-medium-x300.png |
      | build/images/background-small-200x.png |
      | build/images/middleman.png |
      | build/images/middleman-medium-x300.png |
      | build/images/middleman-small-200x.png |

  Scenario: Thumbnail dimensions are correct
    Given a successfully built app at "thumbnails"
    Then the image "build/images/background-medium-x300.png" should have width of "300"
    Then the image "build/images/background-small-200x.png" should have height of "200"

  Scenario: Thumbnails are regenerated when files have changed
    Given a successfully built app at "thumbnails"
    Then I should be able to update an image "images/middleman.png" and the thumbnails regenerate

  Scenario: Thumbnails do not regenerate when source files have not changed
    Given a successfully built app at "thumbnails"
    Then I should be able to rebuild "images/middleman.png" and the thumbnails do not regenerate
