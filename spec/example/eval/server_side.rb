module Example
  module Eval
    class ServerSide
      include EMBox::HasConnection
      include EMBox::HasClient

      delegates_to_client :eval_code

      def status_changed status
        call_start_callback if status == :ready
      end

      def result result
        puts "result: #{result}"
        received_message result

        server.stop_when_all_done
      end

    end
  end
end
