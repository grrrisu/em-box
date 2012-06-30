module Example
  module Evil
    class Server
      include EMBox::HasConnection
      include EMBox::HasClient
      
      delegates_to_client :execute_method

      def result result
        puts "result: #{result}"
        received_message result
        EM.stop
      end

    end
  end
end