module EMBox
  module HasConnection

    def self.included(base)
      base.extend Forwardable
      base.extend ClassMethods
      base.send(:include, InstanceMethods)
    end

    module ClassMethods

      def delegates_to_connection *methods
        def_delegators :@connection, *methods
      end
      alias delegates_to_client delegates_to_connection
      alias delegates_to_server delegates_to_connection

    end

    module InstanceMethods
    
      attr_reader :connection

      def connection= connection
        @connection = connection
        connection.receiver = self
      end

    end

  end
end