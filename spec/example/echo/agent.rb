module Example
  module Echo
    class Agent < EMBox::Client::Agent
    
      # used for test without return value
      def says text
        answer "client: #{text}"
      end
    
      # used for test with return value
      def think
        answer = echo "client is thinking"
        echo answer
      end

    end
  end
end