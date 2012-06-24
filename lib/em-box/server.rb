require 'rbconfig'
require 'json'
require 'rubygems'
require 'eventmachine'

require_relative '../em_box'

module EMBox

  class Server
    
    attr_reader :agents

    def initialize agents = [], options = {}
      @agents       = agents
      @client_class = options[:client_class] || EMBox::Client::Base
      @ruby         = options[:ruby] || File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])
    end

    def add_agent agent
      @agents << agent
    end
    
    def broadcast status
      @agents.each do |agent|
        agent.connection.send_status status
      end
    end
    
    def call_start_callback
      @start_callback.call
    end

    def start &block
      EM.run do
        @agents.each do |agent|
          em_lib = File.expand_path(File.dirname(__FILE__) + '/../em_box.rb')
          cmd    = "#{@ruby} -rrubygems -rjson -reventmachine -r#{em_lib} -e '#{@client_class}.new(\"#{agent.agent_class}\", \"#{agent.agent_file}\")'"
          puts cmd
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