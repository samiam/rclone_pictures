class Album
  attr_reader :lines, :albums, :photos

  def initialize(lines)
    @lines = lines
    @albums = Hash.new { |h, k| h[k] = [] }
    @photos = Hash.new { |h, k| h[k] = [] }
    process
  end

  def include?(photo)
    @photos.has_key?(photo)
  end

  def album_photo_is_in(photo)
    name = Photo.normalize(photo)
    @photos[name] # if @photos.has_key?(photo)
  end

  private

  def process
    @lines.each do |line|
      if match = line.match(/-1 (.*?)\/(.*)/)
        name, file = match[1,2]
        @albums[name] << file
        @photos[file] << name
      end
    end
  end
end

=begin
  def find_photo(file)
    found = []
    @albums.each do |k,v|
      found << k if @albums[k].include?(file)
    end
    found
  end

  def filenames
    @filenames ||= @albums.values.flatten
  end

  def raw_size
    @filenames.size
  end

  def size
    @filenames.uniq.size
  end

  def normalize_name(s)
    s.gsub(/(\s\{.*?\})/, "")
  end

=end
