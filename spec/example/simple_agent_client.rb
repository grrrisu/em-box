require_relative '../../lib/em_box'

module Example
  class SimpleAgentClient < EMBox::Client

    def start_game
      2.times do
        connection.look_around
        connection.move_to [1,0]
      end
    end

  end
end