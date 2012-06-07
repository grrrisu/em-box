require 'rbconfig'
require 'json'
require 'rubygems'
require 'eventmachine'

require_relative 'client_connection'

module EMBox

  class Server

    def initialize agents = [], options = {}
      @agents = agents
      @ruby   = options[:ruby] || File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])
    end

    def add_agent agent
      @agents << agent
    end

    def start
      EM.run do
        @agents.each do |agent|
          agent.connection = EM.popen("#{@ruby} -rrubygems -rjson -reventmachine -r#{agent.client_file} -e '#{agent.client_class}.new'", ClientConnection)
        end
        yield
      end
    end

  end

end