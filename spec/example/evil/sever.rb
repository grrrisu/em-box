module Example
  module Evil
    class Server
      include EMBox::HasConnection
      include EMBox::HasClient

      def execute_method method
        puts "sever execute method #{method}"
        result = connection.execute_method method
        puts "result: #{result}"
        received_message result
        EM.stop
      end

    end
  end
end