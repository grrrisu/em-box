require_relative 'server'

module EMBox

  class TournamentServer < Server

    attr_reader :agents

    def initialize agents = [], options = {}
      @agents       = agents
      super options
    end

    def add_agent agent
      @agents << agent
    end

    def agent_ready connection
      if agents.map(&:connection).all? {|c| c.status == :ready }
        call_start_callback
      end
    end

    def broadcast status
      @agents.each do |agent|
        agent.connection.send_status status
      end
    end

    def start_all_agents &block
      @agents.each do |agent|
        start_agent agent

        # TODO stop game after some time
        EM::add_timer(10) do
          puts "20 sec passed closing connection to agent"
          agent.connection.close_connection
        end
      end
      @start_callback = block
    end

  end
end
