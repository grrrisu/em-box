module Example
  module Eval
    class ServerSide
      include EMBox::HasConnection
      include EMBox::HasClient

      delegates_to_client :eval_code

      def status_changed status
        server.call_start_callback(self) if status == :ready
      end

      def result result
        puts "result: #{result}"
        received_message result
        EM.stop
      end

    end
  end
end
