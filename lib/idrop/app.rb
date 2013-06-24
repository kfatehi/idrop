require 'idrop/watcher'
require 'idrop/machine'

module Idrop
  module App
    @watch_folder = Dir.pwd
    def self.start
      watcher = Watcher.new(@watch_folder)
      mac = Machine.new
      mac.log = watcher.log
      watcher.watch! do |movie|
        mac.upload(movie)
      end
    end
  end
end
