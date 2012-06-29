module Example
  module Evil
    class Agent < EMBox::Client::Agent

      # used for test without return value
      def execute_code method
        $stderr.puts "client executes #{method}"
        __send__ method
      end

      def say_hello
        puts 'hello'
      end

      def eat_cpu
        loop {}
      end

      def fork_and_eat
        fork { loop {} }
      end

      def eat_memory
        100000000000000.times {|i| i.to_s.to_sym}
      end

      def read_env
        ENV.inspect
      end

      def steal_passwords
        File.read '/etc/passwd'
      end

      def kill_process
        exit
      end

      def send_evil_stuff
        __send__ ("t" + "ix" + "e").reverse
      end

      def the_end
        #__END__
      end

      def me
        __FILE__
      end

      def evil_eval
        instance_eval('@client')
      end

      def pollute_namespace
        Float.class_eval "def to_s; 'har har'; end"
        "#{2.0}"
      end

      def require_std_lib
        require 'net/http'
      end

      def access_stdin
        $stdin
      end

      def connect_with_em
        EventMachine::run {
          EventMachine::connect "www.goole.com", 80
        }
      end

      # used for test with return value
      def think
        answer = echo "client is thinking"
        echo answer
      end

    end
  end
end