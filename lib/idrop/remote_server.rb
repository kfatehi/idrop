require 'net/scp'
module Idrop
  module RemoteServer
    module SSH
      def remote_md5 ssh, path
        ssh.exec!(%{ruby -r'digest' -e "print Digest::MD5.file('#{path}').hexdigest"})
      end

      def secure_shell &block
        ssh = Net::SSH.start(@hostname, @username)
        yield ssh
      rescue => ex
        @log.error ex.message
        @log.error ex.backtrace.join("\n")
        @log.error "Unable to connect to #{@hostname} as #{@username}"
      ensure
        ssh.close
      end

      def scp local_path, remote_path
        Net::SCP.upload!(@hostname, @username,
          local_path, remote_path)
      end
    end

    module Rails
      def build_rake_task(command, *args)
        "cd #{@app_root} && RAILS_ENV=production " +
        "bundle exec rake '#{command}[#{args.join(',')}]'"
      end
    end
  end
end