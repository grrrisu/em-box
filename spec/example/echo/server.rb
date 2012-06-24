module Example
  module Echo
    class Server
      include EMBox::HasConnection
      include EMBox::HasClient

      delegates_to_client :says

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
        return "server echo: #{text}"
      end

    end
  end
end