# Middleman Thumbnailer

Generate thumbnail versions of your jpeg & png images

## Installation

Add this line to your `Gemfile`:

```ruby
gem 'middleman-thumbnailer', '~> 0.1'
```

## Configuration

To activate generating thumbnails add the following to `config.rb`:

```ruby
  activate :thumbnailer,
    :dimensions => {
      :small => '200x',
      :medium => '400x300'
    },
    :include_data_thumbnails => true,
    :namespace_directory => %w(gallery)
```

This activates the extension and will only process images in `source/images/gallery`.

For a file called `background.png`, versions named `background-small-200x.png` and `background-medium-400x300.png` will be generated in the same directory.

### Config Options

 * `:include_data_thumbnails`: `Boolean` (Default: `false`) - Enables including a list all image versions generated as the `data-thumbnails`-attribute for each image when using the `thumbnail()` helper

 * `:namespace_directory`: `Array` (Default: `nil`)
   only process images found within this directory **within** `source/images`


## Helpers

 * `thumbnail(image, size, [html_options])`: returns thumbnail a image tag for `image` in `size`
 * `thumbnail_url(image, size)`: returns the url for `image` in `size`
