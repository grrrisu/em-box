module EMBox

  module ServerConnection
    include EventMachine::Protocols::ObjectProtocol
    
    attr_accessor :client

    def serializer
      JSON
    end

    def post_init
      $stderr.puts "preparing client"
      #raise ArgumentError, 'just a test error'
      #Sandbox.seal(500, 50)
      # require agent code
      send_object :status => 'ready'
    end
    
    def send_message message, *args
      send_object :message => message, :arguments => args
    end
    
    def method_missing message, *args, &block
      send_message message, *args
    end

    def receive_object json
      $stderr.puts "server sent #{json}"
      client.send json['message'], *json['arguments']
    end

  end

end