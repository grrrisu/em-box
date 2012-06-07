require_relative '../../lib/em_box'

module Example
  class EchoClient < EMBox::Client
    
    def says text
      connection.echo("client: #{text}")
    end

  end
end