module EMBox

  module ServerConnection
    include EventMachine::Protocols::ObjectProtocol

    attr_accessor :client

    def serializer
      JSON
    end

    def post_init
      #$stderr.puts "client ready"
      send_object :status => 'ready'
    end

    def send_message message, *args
      send_object :message => message, :arguments => args
    end

    def receive_object object
      $stderr.puts "client #{client.object_id}: server sent #{object}"
      client.receive_message object
    end

  end

end
