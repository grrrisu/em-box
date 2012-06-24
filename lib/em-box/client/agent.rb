module EMBox
  
  module Client

    class Agent < BasicObject
    
      def initialize client
        @client = client
      end
      
      def think
        #$stderr.puts agent.look_around
        #$stderr.puts agent.move_to 1, 0
      end
      
      def says text
        echo("client: #{text}")
      end
    
      def method_missing method, *args, &block
        $stderr.puts method, args
        @client.send_message self, method, *args, &block
      end
    
    end
  
  end
  
end