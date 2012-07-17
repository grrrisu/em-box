module Example
  module Eval
    class Agent < EMBox::Client::Agent

      def eval_code code
        $stderr.puts "clients evals #{code}"
        result ::Object.instance_eval(code)
      end

      def eval_code_within_sandbox code
        $stderr.puts "clients evals #{code} within sandbox"
        result instance_eval("@client.sandbox.seal; ::Object.new.instance_eval('hello world')")
      end

    end
  end
end
