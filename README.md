# middleman-svg-fallback

Generate nice JPEG and PNG files from any SVG files in your `images/` folder.

Also, generate gzipped SVGZ files.

*Attention:* This requires [Inkscape](http://inkscape.org/).

## Installation

Add this line to your `Gemfile`:

```ruby
gem 'middleman-svg-fallback'
```

And something like this to your `config.rb`:

```ruby
  require "middleman-svg-fallback"
  activate :svg_fallback,
    :inkscape_bin => '/Applications/Inkscape.app/Contents/Resources/bin/inkscape',
    :inkscape_options => '--export-dpi=100 --export-background-opacity=0'
```

(supposed you're working on a Mac)

Then, during build, middleman-svg-fallback will generate the fallbacks as you would expect and you can use them with a [modernizr](http://modernizr.com/) based CSS rule, like this for example:

```css
.illustration {
  background: url('illustration.svg') 0 0 no-repeat;
}

.no-svg .illustration {
    background: url('illustration.png') 0 0 no-repeat;
}
```

The JPEG files are intended for use with [OpenGraph](http://ogp.me/). Facebook doesn't like PNGs in `og:image` properties, so the JPG versions will come in handy.

## License

MIT; Copyright (c) 2012 Jan Schulz-Hofen

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request