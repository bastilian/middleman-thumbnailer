class Middleman::Thumbnailer::DirGlob
  def self.glob(root, namespaces, filetypes)
    filetypes_with_capitals = filetypes.reduce([]) { |memo, file| memo.concat [file, file.upcase] }
    glob_str = "#{root}/{#{namespaces.join(',')}}/**/*.{#{filetypes_with_capitals.join(',')}}"
    Dir[glob_str]
  end
end
