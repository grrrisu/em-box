module EMBox

  module ClientConnection
    include EventMachine::Protocols::ObjectProtocol

    attr_accessor :receiver, :status, :server
    
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
      if server.agents.map(&:connection).all? {|c| c.status == :ready }
        server.call_start_callback
      end
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
        if method_allowed? json['message']
          receiver.send json['message'], *json['arguments']
        else
          server.unallowed_method self, json['message'].to_sym
        end
      end
    end
    
    # TODO check specific agent interface 
    def method_allowed? method
      ![:exit, :exit!].include? method.to_sym
    end

    def method_missing method, *args, &block
      if status == :ready
        puts "server sending message #{method} with args #{args}"
        send_object :message => method, :arguments => args
      elsif status == :connected
        puts "WARN client not ready"
        EM.add_timer(3) do
          # FIXME check when all clients are ready
          send(method, *args)
        end
      else
        puts "NOT sending #{method}"
      end
    end

    def unbind
      puts 'client closed connection'
      self.status = :closed
      puts get_status
      EM.stop
    end

  end

end