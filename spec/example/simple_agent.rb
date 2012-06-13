module Example
  
  class SimpleAgent
    
    extend Forwardable
      
    def self.capabilites *modules
      methods = modules.map {|m| m.instance_methods }.flatten
      def_delegators :@connection, *methods
    end
    
    def initialize connection
      @connection = connection
    end
    
    def think
      look_around
      move_to [1,0]
    end
    
  end
  
end