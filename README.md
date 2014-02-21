# Middleman Thumbnailer

Generate thumbnail versions of your jpeg & png images


## Important Note

middleman-thumbnailer will only (currently) work with the master branch of middleman (or at least this commit: https://github.com/middleman/middleman/commit/049866ee2e74972292687a7d1dff0e69f942f83a). Sorry, I just did a bunch of debugging of strange behavior & realized I need a before_hook...

Once middleman 3.2.3 is out, it should be all good!

## Installation

Add this line to your `Gemfile`:

```ruby
gem 'middleman-thumbnailer', :git => 'git://github.com/nhemsley/middleman-thumbnailer.git'
```

And something like this to your `config.rb`:

```ruby
  require 'middleman-thumbnailer'
  activate :thumbnailer, 
    :dimensions => {
      :small => '200x',
      :medium => '400x300'
    },
    :include_data_thumbnails => true,
    :namespace_directory => %w(gallery)
```

If you have a file in images called (for example) background.png, thumbnail versions will be created called:
  background-small-200x.png
  background-medium-400x300.png

## Config Options

`:include_data_thumbnails` the list of images will be included in the data-thumbnails attribute for each image displayed with the `thumbnail` helper

`:namespace_directory` only thumbnail images found within this directory (_within_ the images directory of course)


##Helpers

`thumbnail(image, size, [html_options])` will return the thumbnail image tag for the image of the named dimension/size

`thumbnail_url(image, size)` will return the url for the image of the named dimension/size
