#!/usr/bin/ruby

require 'optparse'
require './Album.rb'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: $#{0} remoteA:album/albumA remoteB:album/albumB"

  opts.on("-c", "--checksum", "Verify checksums") do |arg|
    options[:checksum] = arg
  end
end.parse!

if ARGV.size != 2
  puts "Usage"
  exit 0
end

argA, argB = ARGV

print argA, argB
exit

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
