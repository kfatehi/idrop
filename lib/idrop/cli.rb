require 'thor'

module Idrop
  class CLI < Thor
    desc "watch", "Watch current directory"
    option :source, :aliases => ['-s'],
      :banner => "/home/you/downloads",
      :desc => "Folder to watch for mkv files. Defaults to current directory."
    option :destination, :required => true, :aliases => ['-d'],
      :banner => "you@hostname:/path/to/itunes",
      :desc => "Username and path to put processed files. Be sure to copy your public key."

    def watch
      require 'idrop/app'
      source = options[:source] || Dir.pwd
      Idrop::App.start source, options[:destination]
    end
  end
end