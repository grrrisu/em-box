module Example
  class SimpleAgentServer
    include EMBox::HasConnection
    include EMBox::HasClient

    delegates_to_client :start_game

  end
end