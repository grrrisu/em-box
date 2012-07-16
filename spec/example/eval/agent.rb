module Example
  module Eval
    class Agent < EMBox::Client::Agent

      def eval_code code
        $stderr.puts "clients evals #{code}"
        result ::Object.instance_eval(code)
      end

    end
  end
end
