module Example
  module Echo
    class Server
      include EMBox::HasConnection
      include EMBox::HasClient

      delegates_to_client :says

      def status_changed status
        call_start_callback if status == :ready
      end

      # used for test without return value
      def answer text
        puts "received #{text} from client"
        received_message text
        EM.stop
      end

      # used for test with return value
      def echo text
        puts "received #{text} from client"
        received_message text
        connection.return_to_client "server echo: #{text}"

        server.stop_when_all_done
      end

    end
  end
end
