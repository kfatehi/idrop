require 'idrop'

module Idrop
  module App
    def self.start source, destination_info
      transcoder = Idrop::Transcoders::MkvExtractAndMp4Box.new
      watcher = Watcher.new(source)
      mac = Machine.new destination_info
      puts "Destination is set to #{mac}. Make sure you can scp files there..."
      transcoder.log = mac.log = watcher.log
      watcher.watch! do |movie|
        transcoder.perform(movie, remove_original: false)
        mac.upload(movie)
      end
    end
  end
end
