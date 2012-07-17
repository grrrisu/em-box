module Example
  module Evil
    class Agent < EMBox::Client::Agent

      # used for test without return value
      def execute_method method
        $stderr.puts "client executes #{method}"
        result __send__(method)
      end

      def say_hello
        'hello'
      end

      def eat_cpu
        ::Kernel.loop {}
      end

      def fork_and_eat
        ::Kernel.fork { ::Kernel.loop {} }
      end

      def eat_memory
        100000000000000.times {|i| i.to_s.to_sym}
      end

      def read_env
        ::ENV.inspect
      end

      def read_load_path
        $LOAD_PATH
      end

      def read_load_path2
        $:
      end

      def steal_passwords
        ::File.read '/etc/passwd'
      end

      def kill_process
        ::Kernel.exit!
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
        ::Float.class_eval "def to_s; 'har har'; end"
        "#{2.0}"
      end

      def pollute_namespace_with_inline_code
        ::Float.instance_eval "def to_s; 'har har'; end"
        "#{2.0}"
      end

      def require_std_lib
        ::Object.new.send :require, 'net/http'
        #::Kernel.require 'net/http'
      end

      def access_stdin
        $stdin
      end

      def connect_with_em
        ::EM.run {
          ::EM::connect "www.goole.com", 80
        }
      end

      def send_evil_method
        exit! # this will be sent to the server
      end

    end
  end
end
