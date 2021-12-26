class Photo
  attr_reader :duplicates, :filenames

  def initialize(lines)
    @lines = lines
    @filenames = []
    @duplicates = []
    process
  end

  def self.normalize(filename)
    filename.gsub(/(\s\{.*?\})/, "")
  end

  private

  attr_reader :lines

  def process
    lines.each do |line|
      if match = line.match(/^(?:\s+-1 )?(.*)/)
        name = File.basename(match[1])
        duplicates << name if filenames.include?(name)
        filenames << name
      end
    end
  end
end

=begin

  # If a file name is duplicated in a directory then rclone will add the file ID into its name.
  def normalize
    @filenames = []
    @deduped = []
    @raw_filenames.each do |file|
#      name = normalize_name(file)
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

    def raw_size
      @raw_filenames.size
    end
    def size
      @filenames.size
    end
    def normalize_file(s)
      normalize_name(s)
    end
  #  def filenames; @raw_filenames; end
=end
