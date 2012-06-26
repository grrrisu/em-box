require 'fiber'

require_relative 'base'

require_relative 'server_connection'
#require_relative '../sandbox/sandbox'

module EMBox
  
  module Client

    class SynchronizedClient < Base
      
      attr_reader :fiber

      def start
        @fiber = Fiber.new do
          super
        end
        @fiber.resume
      end
      
      def receive_message object
        if object['return_value']
          #$stderr.puts "client #{object_id}: received return value #{object['return_value']}"
          @fiber.resume *object['return_value']
        else
          super
        end
      end
      
    protected

      def send_to_connection method, *args
        super
        Fiber.yield
      end

    end
  
  end

end