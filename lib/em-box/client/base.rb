require 'fiber'

require_relative 'server_connection'
#require_relative '../sandbox/sandbox'

module EMBox
  
  module Client

    class Base
      
      attr_reader :fiber, :agent, :connection

      def initialize
        $stderr.puts "agent #{self.class} initialized"
        start
      end

      def start
        $stderr.puts 'starting client'
        EM.run do
          begin
            @connection = EM::attach($stdin, ServerConnection)
            @connection.client = self
            
            @agent = Agent.new(self) # TODO create specific Agent
            #start_agent           

            EM.add_timer(2) do
              EM.stop
            end
          rescue Exception => e
            $stderr.puts e.message
            @server.send_object :exception => e.message
            EM.stop
          end
        end
      end
      
      def start_agent
        @fiber = Fiber.new do
          begin
            agent.think
          rescue Exception => e
            $stderr.puts e.message
            $stderr.puts *e.backtrace.join("\n")
          end
        end
        @fiber.resume
      end
    
      def send_message caller, method, *args, &block
        if allowed? caller, method
          @connection.send_message method, *args
          $stderr.puts Fiber.current
          Fiber.yield rescue FiberError
        end
      end
      
      def allowed? caller, method
        true
      end
      
      def receive_message object
        if object['return_value']
          @fiber.resume object['return_value']
        else
          #raise self.inspect
          send object['message'], *object['arguments']
        end
      end

    end
  
  end

end