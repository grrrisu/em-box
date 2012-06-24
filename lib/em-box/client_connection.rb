module EMBox

  module ClientConnection
    include EventMachine::Protocols::ObjectProtocol

    attr_accessor :receiver, :status, :server

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

    def receive_object json
      puts "client sent #{json}"
      if json['status']
        self.status = json['status'].to_sym
      else
        receiver.send json['message'], *json['arguments']
      end
    end

    def method_missing method, *args, &block
      if status == :ready
        send_object :message => method, :arguments => args
      else
        puts "WARN client not ready"
        EM.add_timer(3) do
          # FIXME check when all clients are ready
          send(method, *args)
        end
      end
    end

    def unbind
      puts 'client closed connection'
      puts get_status
      EM.stop
    end

  end

end