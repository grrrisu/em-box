module EMBox
  module HasClient

    def self.included(base)
      base.extend HasConnection
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
    
      attr_reader :agent_class, :agent_file

      def initialize options
        @agent_class = options[:agent_class]
        @agent_file  = options[:agent_file]
      end

    end

  end
end