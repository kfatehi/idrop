require 'idrop/watcher'
require 'idrop/machine'

module Idrop
  module App
    def self.start source, destination_info, script=nil
      watcher = Watcher.new(source)
      mac = Machine.new destination_info
      puts "Destination is set to #{mac}. Make sure you can scp files there..."
      mac.log = watcher.log
      watcher.watch! do |movie|
        if script
          # evaluate script
        else
          # default behavior:
          mac.upload(movie) # need to change this, it's transcoding too now remember
        end
      end
    end
  end
end
