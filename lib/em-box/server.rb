require 'rbconfig'
require 'json'
require 'rubygems'
require 'eventmachine'

require_relative 'client_connection'

module EMBox

  class Server
    
    attr_reader :agents

    def initialize agents = [], options = {}
      @agents = agents
      @ruby   = options[:ruby] || File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])
    end

    def add_agent agent
      @agents << agent
    end
    
    def call_start_callback
      @start_callback.call
    end

    def start &block
      EM.run do
        @agents.each do |agent|
          cmd = "#{@ruby} -rrubygems -rjson -reventmachine -r#{agent.client_file} -e '#{agent.client_class}.new' -T3"
          agent.connection = EM.popen(cmd, ClientConnection)
          agent.connection.server = self
          
          EM::add_timer(2) do
            unless agent.connection.status == :ready
              agent.connection.close
            end
          end
        end
        @start_callback = block
      end
    end

  end

end