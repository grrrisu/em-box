module EMBox
  
  module Sandbox
    
    class Base
      
      attr_reader :config
      
      def initialize config_file
        config_file = File.expand_path(File.dirname(__FILE__) + '/default_config.json') unless config_file
        read_config_file config_file
      end
      
      def read_config_file config_file
        @config = JSON.load(File.open(config_file))['sandbox']
        $stderr.puts config.inspect
      end
      
      def seal
        $stderr.puts 'sealing sandbox...'
        
        # RAM limit
        Process.setrlimit(Process::RLIMIT_AS,  config['memory']*1024*1024) # no effect on OSX but on Linux
        # CPU time limit. 5s means 5s of CPU time.
        Process.setrlimit(Process::RLIMIT_CPU, config['cpu_time'])
        # number of processes for the user
        Process.setrlimit(Process::RLIMIT_NPROC, config['subprocesses'])
        
        remove_globals
        
        $SAFE = config['safe_level']
      end
      
      def remove_globals
        # trusted globals
        # $stdin, $stdout, $stderr
        # $0, $*, $?, $$, $~, $1, $&, $+, $`, $', $!, $@
        
        # LOAD PATH
        $:.clear
        $LOAD_PATH.clear
        
        ENV.clear
      end
      
    end
    
  end
  
end