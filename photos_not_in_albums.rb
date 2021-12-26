#!/usr/bin/ruby
# rclone ls remote:media > ls_media_all
# $0 ls_media_all

class Photos
  attr_reader :filenames, :deduped

  def initialize(lines)
    @lines = lines
    process
    normalize
  end

  def raw_size
    @raw_filenames.size
  end
  def size
    @filenames.size
  end
  def normalize_file(s)
    normalize_name(s)
  end

  private

  def process
    @raw_filenames = []
    @lines.each do |line|
      if match = line.match(/media\/all\/(.*)/)
        name = match[1]
        puts "Duplicate filename #{name}" if @raw_filenames.include?(name)
        @raw_filenames << name
      end
    end
  end

  # If a file name is duplicated in a directory then rclone will add the file ID into its name.
  def normalize
    @filenames = []
    @deduped = []
    @raw_filenames.each do |file|
      name = normalize_name(file)
      @filenames << name
      if name != file
        @deduped << file
      end
    end
    @filenames.uniq!
  end

  def normalize_name(s)
    s.gsub(/(\s\{.*?\})/, "")
  end
end

class Albums
  attr_reader :albums

  def initialize(lines)
    @lines = lines
    process
  end

  def find_photo(file)
    found = []
    @albums.each do |k,v|
      found << k if @albums[k].include?(file)
    end
    found
  end

#  def photos_in_multiple_albums
#
#    @albums.each do |k,v|
#      v.each do |file|
#        @
#        (@albums.keys - k).each do |key|
#          found << k if @albums[key].include?(file)
#      end
#    end
#  end

  def filenames
    @filenames ||= @albums.values.flatten
  end

  def raw_size
    @filenames.size
  end

  def size
    @filenames.uniq.size
  end

  private

  def process
    @albums = Hash.new { |h, k| h[k] = [] }

    @lines.each do |line|
      if match = line.match(/album\/(.*?)\/(.*)/)
        name, file = match[1,2]
        @albums[name] << file
      end
    end
  end
end

lines = ARGF.readlines.map(&:chomp!)
photos = Photos.new(lines)
albums = Albums.new(lines)

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
