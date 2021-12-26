#!/usr/bin/ruby

require 'optparse'
require './Photo.rb'
require './Album.rb'
require './Analyze.rb'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: $#{0} [options]"

  opts.on("-v", "--verbose", "Verbose") do |arg|
    options[:verbose] = arg
  end
  opts.on("-m", "--media MEDIA", "Media file") do |arg|
    options[:media] = arg
  end
  opts.on("-a", "--album ALBUMS", "Album file") do |arg|
    options[:album] = arg
  end
end.parse!

unless options[:media] && options[:album]
  puts "Both media and album args required"
  exit 1
end

def read_file(filename)
  File.open(filename).readlines.map(&:chomp)
end

# ./remote_albums.rb lsf_all ls_album_all
photos = Photo.new(read_file(options[:media]))
albums = Album.new(read_file(options[:album]))
analysis = Analyze.new(photos, albums)

puts "=== Albums where duplicate filenames exist ==="
analysis.albums_where_duplicate_files_exist_in

puts "\n\n"
puts "=== Photos not in albums ==="
analysis.photos_not_in_albums
