module Example
  class TestServer < EMBox::Server
    attr_accessor :stop_after

    def stop_when_all_done
      @current_counter ||= 0
      @current_counter += 1
      unless @current_counter < stop_after
        stop
      end
    end
  end
end
