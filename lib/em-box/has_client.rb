module EMBox
  module HasClient

    def self.included(base)
      base.extend HasConnection
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods

      attr_accessor :server, :start_callback
      attr_reader :agent_class, :agent_file

      def setup options
        @agent_class = options[:agent_class]
        @agent_file  = options[:agent_file]
      end

      # status: connected, ready, running, stopping, closed
      def status_changed status
        # overwrite
        # eg. server.call_start_callback(self) if status == :ready
      end

      def receive_exception exception, message
        raise Exception, "client raises #{exception}: #{message}"
      end

      def receive_message message, *args
        send message, *args
      end

      def receive_unallowed_message message, *args
        raise Exception, "client sent unallowed message #{message}"
      end

      def message_allowed? message
        # TODO check specific agent interface
        ![:exit, :exit!].include? message.to_sym
      end

      def method_missing message, *args, &block
        connection.send_message message, *args
      end

      def call_start_callback
        start_callback.call self
      end

    end

  end
end
