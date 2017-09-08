module Idlc
  module Build
    module Httpd
      class << self
        def private_ip
          Socket.ip_address_list.detect(&:ipv4_private?).ip_address
        end

        def start(root_dir, sleep_time = 3)
          httpd = server(root_dir)

          pid = Process.fork
          if pid.nil?
            # In child
            exec((
              trap('INT') { httpd.shutdown }
              httpd.start
              # ignore the nil excpetion here, this happens when the child process exits
            )) rescue nil
          else
            # In parent
            Process.detach(pid)
          end

          sleep sleep_time

          # Return process id
          pid
        end

        def stop(pid)
          Process.kill('INT', pid) unless pid.nil?
        end

        private

        def server(root)
          # get a random port number
          port = Random.rand(49_152...65_535)
          ENV['HTTPD_PORT'] = port.to_s

          WEBrick::HTTPServer.new(
            Port: port,
            DocumentRoot: root
          )
        end
      end
    end
  end
end
