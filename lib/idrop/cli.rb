require 'thor'

module Idrop
  class CLI < Thor
    desc "watch", "Watch current directory"
    option :host => :required
    option :username => :required
    option :password => :required
    def watch
      require 'idrop/app'
      Idrop::App.start
    end
  end
end