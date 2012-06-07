require_relative 'server_connection'
require_relative '../sandbox/sandbox'

module EMBox

  class Client

    attr_reader :connection

    def initialize
      $stdout.puts 'agent initialized'
      start
    end

    def start
      $stderr.puts 'starting client'
      EM.run do
        begin
          @connection = EM::attach($stdin, ServerConnection)
          @connection.client = self

          EM.add_timer(5) do
            EM.stop
          end
        rescue Exception => e
          $stderr.puts e.message
          @server.send_object :exception => e.message
          EM.stop
        end
      end
    end

  end

end