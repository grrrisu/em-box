module EMBox

  module ClientConnection
    include EventMachine::Protocols::ObjectProtocol

    attr_accessor :receiver, :status

    at_exit { puts "cc server exiting..." }

    def serializer
      JSON
    end

    def post_init
      puts 'client connected'
      status = :connected
      puts "client pid #{get_pid}"
    end

    def status= status
      @status = status
      receiver.status_changed(@status)
    end

    def send_status status
      send_object :status => status
    end

    def return_to_client *args
      send_object :return_value => args
    end

    def receive_object json
      puts "client sent #{json}"
      if json['status']
        self.status = json['status'].to_sym
      elsif json['exception']
        puts "client raised #{ json['exception']}: #{json['message']}"
        receiver.receive_exception json['exception'], json['message']
      else
        if receiver.message_allowed? json['message']
          receiver.receive_message json['message'], *json['arguments']
        else
          receiver.receive_unallowed_message json['message'], *json['arguments']
        end
      end
    end

    def method_missing message, *args, &block
      send_message message, *args
    end

    def send_message message, *args
      if status == :ready
        puts "server sending message #{message} with args #{args}"
        send_object :message => message, :arguments => args
      elsif status == :connected
        puts "WARN client not ready"
        EM.add_timer(3) do
          # FIXME check when all clients are ready
          send(method, *args)
        end
      else
        puts "connection status #{status} -> NOT sending #{message}"
      end
    end

    def unbind
      puts 'client closed connection'
      self.status = :closed
      puts get_status
    end

  end

end
