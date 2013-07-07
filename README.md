# Middleman Thumbnailer

Generate thumbnail versions of your jpeg & png images

## Installation

Add this line to your `Gemfile`:

```ruby
gem 'middleman-thumbnailer', :git => 'git://github.com/nhemsley/middleman-thumbnailer.git'
```

And something like this to your `config.rb`:

```ruby
  require "middleman-thumbnailer"
  activate :thumbnailer, 
    :dimensions => {
      :small => '200x',
      :medium => '400x300'
    },
    :include_data_thumbnails => true
```

If you have a file in images called (for example) background.png, thumbnail versions will be created called:
  background-small-200x.png
  background-medium-400x300.png

If the `:include_data_thumbnails` option is set to true, the list of images will be shown for each image displayed with the `thumbnail` helper

##Helpers

There is one helper, `thumbnail(image, size)` which will output the thumbnail name for that image