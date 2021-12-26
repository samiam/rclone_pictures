class Analyze
  attr_reader :photos, :albums

  def initialize(photos, albums)
    @photos = photos
    @albums = albums
  end

  # Show albums a duplicate filename is in
  # Only the filename string is a duplicate;
  # the photo itself is (probably) different
  def albums_where_duplicate_files_exist_in
    photos.duplicates.each do |photo|
      puts "Photo: #{photo}"
      puts "In albums: #{albums.album_photo_is_in(photo)}"
    end
  end

  # See if each photo is in an album
  def photos_not_in_albums
    photos.filenames.each do |photo|
      # simple case - it is
      next if albums.include?(photo)

      # The photo name includes the duplicate hash
      # So strip that off and see if photo is in album
      # IMG_0008 {AL0dunET7M-jHrzaugRTzixlHHx0mxs2N8gMK6nMKSddx1Wf4WBSIJwgFE4YaG97b5xNMAJj4qx8x1fAN9EIWViaPr4FX-qasw}.jpeg
      photo_clean = Photo.normalize(photo)
      next if albums.include?(photo_clean)

      # Else photo not in an album
      puts "#{photo}"
    end
  end
end

=begin
puts "======================================"
puts "Files that are not in albums:"
(photos.filenames - albums.filenames).each do |missing|
  puts missing
end

puts
puts "Files in albums that are not in 'all':"
(albums.filenames - photos.filenames).each do |missing|
  puts "'#{missing}' is in album #{albums.find_photo(missing)}"
end
puts "======================================"

puts
puts "====== Photo Information ============="
puts "Total files count: #{photos.raw_size}"
puts "Total files removing duplicates count: #{photos.size}"
puts "Number of duplicate files: #{photos.raw_size - photos.size}"
puts "======================================"

puts
puts "======== Album Information ==========="
puts "Total files in albums count: #{albums.raw_size}"
puts "Total files in albums removing duplicates count: #{albums.size}"
puts "======================================"

puts
puts "======================================"
puts "Files with same names and the albums they are in:"
photos.deduped.map do |file|
  puts "#{file} is in albums: #{albums.find_photo( photos.normalize_file(file) )}"
end
=end
