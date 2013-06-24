require 'idrop/transcoders/base'
require 'fileutils'

module Idrop
  module Transcoders
    ##
    # A transcoder class that repackages h264/ac3 mkv's as mp4
    # Depends on mkvtoolnix
    # Mac: brew install mkvtoolnix MP4Box
    class MkvExtractAndMp4Box < Base
      def initialize
        @deps = %w{mkvmerge mkvextract MP4Box}
        super
      end

      def perform(movie, opts)
        @dir = File.dirname(movie.filepath)
        require 'pry'
        binding.pry
        inspect movie.filepath
        extract movie.filepath
        @original_mkv = movie.filepath.clone
        movie.filename = movie.filename.gsub('.mkv', '.mp4')
        movie.filepath = File.join(@dir, movie.filename)
        box movie.filepath
        cleanup
        if opts[:remove_original]
          @log.info "Removing original mkv"
          FileUtils.rm @original_mkv
        end
      end

      private

      def inspect filepath
        @tracks = {}
        info = `mkvmerge --identify '#{filepath}'`
        info.split("\n").select{|l| l.match(/Track/)}.map do |line|
          track = line.match(/ID (\d): (\w+)/)
          case track[2]
          when 'video'
            @tracks[track[1]] = File.join(@dir, 'video.h264')
          when 'audio'
            @tracks[track[1]] = File.join(@dir, 'audio.ac3')
          end
        end
      end

      def extract filepath
        @log.info "Extracting tracks"
        tracks = @tracks.map{|k,v| "#{k}:'#{v}'"}.join(' ')
        `mkvextract tracks '#{filepath}' #{tracks}`
      end

      def box filepath
        @log.info "Boxing mp4"
        tracks = @tracks.values.map{|t| "-add '#{t}'"}.join(' ')
        `MP4Box -fps 24 #{tracks} '#{filepath}'`
      end

      def cleanup
        @tracks.values.each do |track| 
          @log.info "Removing #{File.basename(track)} track"
          FileUtils.rm track
        end
      end
    end
  end
end