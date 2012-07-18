module EMBox

  module Client

    class Agent

      def initialize client
        @client = client
      end

      def think
        #$stderr.puts agent.look_around
        #$stderr.puts agent.move_to 1, 0
      end

      def method_missing method, *args, &block
        @client.send_message self, method, *args, &block
      end

    end

  end

end
