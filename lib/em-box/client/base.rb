require_relative 'server_connection'
#require_relative '../sandbox/sandbox'

module EMBox
  
  module Client

    # ServerConnection(IO) <-> Client(Doorkeeper) <-> Agent(think)
    class Base
      
      attr_reader :agent, :connection

      def initialize agent_class, agent_file
        $stderr.puts "agent #{self.class} initialized"
        run(agent_class, agent_file)
      end

      def run(agent_class, agent_file)
        $stderr.puts 'starting client'
        EM.run do
          begin
            @connection = EM::attach($stdin, ServerConnection)
            @connection.client = self
            require agent_file # TODO may just pass the code
            @agent = constantize(agent_class).new(self)
            
            EM.add_timer(2) do
              EM.stop
            end
          rescue Exception => e
            $stderr.puts e.message
            @connection.send_object :exception => e.message
            EM.stop
          end
        end
      end
      
      def start
        start_agent
      rescue Exception => e
        $stderr.puts e.message
        $stderr.puts *e.backtrace.join("\n")
      end
      
      def start_agent
        agent.think
      end
    
      def send_message caller, method, *args, &block
        if allowed? caller, method
          send_to_connection method, *args
        end
      end
      
      def allowed? caller, method
        true
      end
      
      def receive_message object
        if status = object['status']
          change_status(status)
        else 
          @agent.send object['message'], *object['arguments']
        end
      end
      
    protected
    
      def constantize class_name
        class_name.split('::').inject(Object){|namespace, name| namespace.const_get(name)}
      end
    
      def send_to_connection method, *args
        @connection.send_message method, *args
      end
      
      def change_status(status)
        if status == 'start'
          start
        elsif status == 'stop'
          EM.stop
        end
      end

    end
  
  end

end