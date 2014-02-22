require 'RMagick'

Then(/^the image "(.*?)" should have width of "([0-9]*?)"$/) do |path, width|
  full_path = File.join(current_dir, path)
  image = ::Magick::Image.read(full_path).first
  image.columns.should == width.to_i
end

Then(/^the image "(.*?)" should have height of "(.*?)"$/) do |path, height|
  full_path = File.join(current_dir, path)
  image = ::Magick::Image.read(full_path).first
  image.rows.should == height.to_i
end
