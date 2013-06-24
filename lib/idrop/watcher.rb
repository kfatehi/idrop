require 'logger'

module Idrop
  class Watcher
    FILE_EXTENSIONS = 'mkv'
    attr_reader :log
    def initialize(target)
      @watch_folder = File.expand_path(target)
      FileUtils.mkdir_p(@data_dir = File.join(@watch_folder, "watcher"))
      FileUtils.mkdir_p(log_dir = File.join(@data_dir, 'log'))
      @keepalive_file = FileUtils.touch(File.join(@data_dir, 'keepalive'))[0]
      @logpath = File.join(log_dir, 'watcher.log')
      @log = Logger.new(@logpath, 'daily')
      @log.info "Watcher initialized with target directory: #{@watch_folder}"
      @log.info "Watcher will shutdown if you delete this keepalive file: #{@keepalive_file}"
    end

    def keepalive?
      File.exists?(@keepalive_file)
    end

    def movies
      movies = []
      Dir.glob(File.join(@watch_folder, "**/*.{#{FILE_EXTENSIONS}}")) do |path|
        next if path.include? 'watcher' # shit sorry.
        movies << Movie.new(path)
        @log.info "Movie appears: #{path}"
      end
      return movies
    end

    def watch! &block
      puts "Recursively watching #{@watch_folder} for #{FILE_EXTENSIONS} files"
      puts "Logging to #{@logpath}"
      while keepalive? do
        movies.each do |movie|
          if movie.valid?
            begin
              @log.info "Movie appears."
              block.call(movie)
            rescue => e
              @log.warn "Upload Error!"
              @log.error e.message
              @log.error e.backtrace.join("\n")
            end
          end
        end
        sleep 5
      end
      @log.info "Keepalive file (#{@keepalive_file}) has been destroyed by user. Shutting down."
      @log.info "#{@watch_folder} is no longer being watched. Goodbye!"
      exit 0
    end
  end
end
