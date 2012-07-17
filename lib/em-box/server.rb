require 'rbconfig'
require 'json'
require 'rubygems'
require 'eventmachine'

require_relative '../em_box'

module EMBox

  class Server

    at_exit { puts "server exiting..." }

    def initialize options = {}
      @client_class = options[:client_class] || EMBox::Client::Base
      @ruby         = options[:ruby] || File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])
    end

    def start &block
      EM.run do
        yield self
      end
    end

    def stop
      EM.stop
    end

    # agent includes HasClient
    def start_agent agent, &block
      em_lib = File.expand_path(File.dirname(__FILE__) + '/../em_box.rb')
      cmd    = "#{@ruby} -rrubygems -rjson -reventmachine -r#{em_lib} -e '#{@client_class}.new(\"#{agent.agent_class}\", \"#{agent.agent_file}\")'"
      agent.connection      = EM.popen(cmd, ClientConnection)
      agent.server          = self
      agent.start_callback  = block if block_given?

      EM::add_timer(2) do
        unless agent.connection.status == :ready
          agent.connection.close_connection
        end
      end
    end

  end

end
