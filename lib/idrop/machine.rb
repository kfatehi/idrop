require 'idrop/remote_server'

module Idrop
  class Machine
    include RemoteServer::SSH
    include RemoteServer::Rails

    attr_accessor :log

    def initialize info
      if info.nil?
        raise InsufficientInformationError
      elsif matches = info.match(/(.*)@(.*):(.*)/)
        @username = matches[1]
        @hostname = matches[2]
        @remote_directory = matches[3]
      elsif matches = info.match(/(.*)@(.*)/)
        @username = matches[1]
        @hostname = matches[2]
      else
        @username = `whoami`.strip
        @hostname = info
      end
      @remote_directory ||= "~"
    end

    def upload movie
      @success = false
      remote_file_path = File.join(@remote_directory, movie.filename)
      secure_shell do |ssh|
        @log.info "Now uploading #{movie.filename} to #{remote_file_path}."

        begin
          scp movie.filepath, remote_file_path
          @log.info "Upload complete."
          `rm #{movie.filepath}`
        end until identical_checksum?(ssh, movie, remote_file_path)

        @log.info "Verified checksum. Calling 'inject_media' rake task on the remote machine."
      end
      return @success
    end

    def identical_checksum? ssh, movie, remote_file_path
      if movie.md5 == remote_md5(ssh, remote_file_path)
        @log.info "Checksum verified."
        @success = true
      else
        @log.info "Checksum failed. Will delete remote file and re-upload."
        ssh.exec!("rm '#{remote_file_path}'")
        @success = false
      end
    end

    def to_s
      "#{@username}@#{@hostname}:#{@remote_directory}"
    end
  end
end