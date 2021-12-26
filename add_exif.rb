#!/usr/bin/env ruby
# Add exif timestamp based on filename exported

USER = "John Smith"

# Rename first
def rename_files
  Dir.glob("*").each do |name|
    if match = name.match(/(.*) - #{USER} -(.*)/)
      normalized = (match[1] + match[2]).gsub(" ", "_")
      File.rename(name, normalized)
    else
      puts "Unable to parse filename: #{name}"
    end
  end
end

# Timestamp based on rename filename
def add_timestamp
  Dir.glob("*").each do |name|
    if match = name.match(/^(\d+-\d+-\d+)_(\d+_\d+_\d+)/)
      timestamp = match[1].gsub("-", ":") + " " + match[2].gsub("_", ":")
      puts timestamp

      str = <<~EOF
      set Exif.Image.DateTime                          Ascii      #{timestamp}
      set Exif.Photo.DateTimeOriginal                  Ascii      #{timestamp}
      set Exif.Photo.DateTimeDigitized                 Ascii      #{timestamp}
      EOF

      File.open("/tmp/cmd.txt", "w") do |fn|
        fn.puts str
      end

      system " exiv2 -m /tmp/cmd.txt mo '#{name}'"
    else
      puts "Unable to parse filename: #{name}"
    end
  end
end
