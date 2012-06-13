require_relative '../../lib/em_box'

require_relative 'simple_agent_capability'
require_relative 'simple_agent'

module Example
  class SimpleAgentClient < EMBox::Client

    def start_game
      SimpleAgent.capabilites SimpleAgentCapability
      agent = SimpleAgent.new(connection)
      
      Thread.fork do
        $SAFE = 3
        2.times { agent.think }
      end
    end

  end
end