require_relative 'server_connection'

module EMBox

  module Client

    # ServerConnection(IO) <-> Client(Doorkeeper) <-> Agent(think)
    class Base

      attr_reader :agent, :connection

      at_exit { $stderr.puts "client exiting..." }

      def initialize agent_class, agent_file, config_file = nil
        #$stderr.puts ENV.inspect
        #$stderr.puts "client #{object_id}: agent #{self.class} initialized"
        @sandbox = Sandbox::Base.new(config_file)
        run(agent_class, agent_file)
      end

      def rescue_error
        yield
      rescue Exception => e
        $stderr.puts "client #{object_id}: #{e.message}"
        $stderr.puts *e.backtrace.join("\n")
        @connection.send_object :exception => e.class.name, :message => e.message
      end

      def run(agent_class, agent_file)
        #$stderr.puts "running client #{object_id}"
        EM.run do
          rescue_error do
            @connection = EM::attach($stdin, ServerConnection)
            @connection.client = self
            require agent_file # TODO may just pass the code
            @agent = constantize(agent_class).new(self)

            EM.add_timer(5) do
              #EM.stop
            end
          end
        end
      end

      def start
        rescue_error do
          @sandbox.seal
          start_agent
        end
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
        rescue_error do
          if status = object['status']
            change_status(status)
          else
            @agent.send object['message'], *object['arguments']
          end
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
        elsif status == 'seal'
          @sandbox.seal
        elsif status == 'stop'
          EM.stop
        end
      end

    end

  end

end
