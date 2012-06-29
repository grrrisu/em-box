require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Evil", :focus => true do

  before :each do
    @agent_on_server = Example::Evil::Server.new(:agent_class => 'Example::Evil::Agent',
                        :agent_file  => File.expand_path(File.dirname(__FILE__) + '/../example/evil/agent'))
    @server = EMBox::Server.new [@agent_on_server]
  end

  it "server should receive an answer for say hello" do
    @agent_on_server.should_receive(:received_message).with(nil).once
    @server.start do
      @agent_on_server.execute_method :say_hello
    end
  end

  # Testing Process RLimits only works on a Linux box, not on OS X
  # this should run on Travis
  if RUBY_PLATFORM =~ /linux/

    it "server should receive an exception if agent tries to eat all cpu time" do
      @agent_on_server.should_receive(:received_message).with(nil).once
      @server.start do
        @agent_on_server.execute_method :eat_cpu
      end
    end

    it "server should receive an exception if agent tries to eat all cpu time in a subprocess" do
      @agent_on_server.should_receive(:received_message).with(nil).once
      @server.start do
        @agent_on_server.execute_method :fork_and_eat
      end
    end

    it "server should receive an exception if agent tries to eat all memory" do
      @agent_on_server.should_receive(:received_message).with(nil).once
      @server.start do
        @agent_on_server.execute_method :eat_memory
      end
    end

  end

  it "agent should not be able to read ENV" do
    @agent_on_server.should_receive(:received_message).with(nil).once
    @server.start do
      @agent_on_server.execute_method :read_env
    end
  end

  it "agent should not be able to read passwords" do
    @agent_on_server.should_receive(:received_message).with(nil).once
    @server.start do
      @agent_on_server.execute_method :steal_passwords
    end
  end

  it "agent should not be able to kill the process" do
    @agent_on_server.should_receive(:received_message).with(nil).once
    @server.start do
      @agent_on_server.execute_method :kill_process
    end
  end

  it "agent should not be able to kill the process over send" do
    @agent_on_server.should_receive(:received_message).with(nil).once
    @server.start do
      @agent_on_server.execute_method :send_evil_stuff
    end
  end

  it "agent should not be able to get current path" do
    @agent_on_server.should_receive(:received_message).with(nil).once
    @server.start do
      @agent_on_server.execute_method :me
    end
  end

  it "agent should not be able to pollute namspaces" do
    @agent_on_server.should_receive(:received_message).with(nil).once
    @server.start do
      @agent_on_server.execute_method :pollute_namespace
    end
  end

  it "agent should not be able to require std libraries" do
    @agent_on_server.should_receive(:received_message).with(nil).once
    @server.start do
      @agent_on_server.execute_method :require_std_lib
    end
  end

  it "agent should not be able to access stdin" do
    @agent_on_server.should_receive(:received_message).with(nil).once
    @server.start do
      @agent_on_server.execute_method :access_stdin
    end
  end

end