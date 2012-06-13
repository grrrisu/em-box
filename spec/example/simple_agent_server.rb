module Example
  class SimpleAgentServer
    include EMBox::HasConnection
    include EMBox::HasClient

    delegates_to_client :start_game

    def echo text
      puts "received #{text} from client"
      received_message text
      EM.stop
    end

  end
end