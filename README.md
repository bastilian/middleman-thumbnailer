# middleman-thumbnailer

Generate thumbnail versions of your jpeg & png images

## Installation

Add this line to your `Gemfile`:

```ruby
gem 'middleman-thumbnailer', :git => 'https://github.com/nhemsley/middleman-directory.git'
```

And something like this to your `config.rb`:

```ruby
  require "middleman-thumbnailer"
  activate :thumbnailer, 
    :dimensions => {
      :small => '200x',
      :medium => '400x300'
    }
```

If you have a file in images called (for example) background.png, thumbnail versions will be created called:
  background-small-200x.png
  background-medium-400x300.png
