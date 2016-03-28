require 'RMagick'

require 'middleman-thumbnailer/thumbnail-generator'

Then(/^the image "(.*?)" should have width of "([0-9]*?)"$/) do |path, width|
  full_path = File.join(expand_path("."), path)
  image = ::Magick::Image.read(full_path).first

  expect(image.columns).to eq(width.to_i)
end

Then(/^the image "(.*?)" should have height of "(.*?)"$/) do |path, height|
  full_path = File.join(expand_path("."), path)
  image = ::Magick::Image.read(full_path).first

  expect(image.rows).to eq(height.to_i)
end

Then (/^I should be able to rebuild "(.*?)" and the thumbnails do not regenerate$/) do |path|
  image_path = File.join(expand_path("."), 'build', path)

  specs =  {
    :small => '200x',
    :medium => 'x300'
  }
  thumbnail_paths = ::Middleman::ThumbnailGenerator.specs(image_path, specs)
  thumbnail_path = thumbnail_paths[:small][:name]
  current_mtime = File.mtime(thumbnail_path)
  sleep 1
  step %Q{I run `middleman build`}
  new_mtime = File.mtime(thumbnail_path)

  expect(new_mtime).to eq(current_mtime)
end

Then (/^I should be able to update an image "(.*?)" and the thumbnails regenerate$/) do |path|
  source_path = File.join(expand_path("."), 'source', path)
  image_path = File.join(expand_path("."), 'build', path)
  specs =  {
    :small => '200x',
    :medium => 'x300'
  }
  thumbnail_paths = ::Middleman::ThumbnailGenerator.specs(image_path, specs)
  original_mtime = File.mtime(image_path)
  sleep 1
  updated_mtime = Time.now
  File.utime(updated_mtime, updated_mtime, source_path)
  step %Q{I run `middleman build`}
  thumbnail_path = thumbnail_paths[:small][:name]
  new_mtime = File.mtime(thumbnail_path)

  expect(new_mtime.sec).to eq(updated_mtime.sec)
end
