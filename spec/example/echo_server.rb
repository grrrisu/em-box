module Example
  class EchoServer
    include EMBox::HasConnection
    include EMBox::HasClient

    delegates_to_client :says

    def echo text
      puts "received #{text} from client"
    end

  end
end