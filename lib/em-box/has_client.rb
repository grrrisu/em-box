module EMBox
  module HasClient

    def self.included(base)
      base.extend HasConnection
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
    
      attr_reader :client_class, :client_file

      def initialize options
        @client_class = options[:client_class]
        @client_file  = options[:client_file]
      end

    end

  end
end