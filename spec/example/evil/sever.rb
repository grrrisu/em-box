module Example
  module Evil
    class Server
      include EMBox::HasConnection
      include EMBox::HasClient

      delegates_to_client :execute_method

      def status_changed status
        if status == :ready
          call_start_callback
        elsif status == :closed
          server.stop
        end
      end

      def receive_exception exception, message
        server.stop
        raise Exception, "#{exception}: #{message}"
      end

      def result result
        puts "result: #{result}"
        received_message result
        server.stop_when_all_done
      end

    end
  end
end
