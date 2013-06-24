module Idrop
  class Movie
    attr_accessor :folder_name, :filepath, :filename, :transcoder
    def initialize(filepath)
      @valid = false
      @filename = File.basename filepath
      @filepath = File.expand_path filepath
      @dir = File.dirname filepath
    end

    def md5
      Digest::MD5.file(@filepath).hexdigest
    end

    def current_file_size
      File.stat(@filepath).size rescue 0
    end

    def missing?
      !File.exists?(@filepath)
    end

    def valid? # TODO Verbose Logging
      if missing?
        return false
      else
        return true
      end
    end

    def to_s
      @filename
    end
  end
end