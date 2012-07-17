require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Evil" do

  def execute_method method
    @server.stop_after = 1
    @server.start do |server|
      server.start_agent(@agent_on_server) do |agent|
        agent.connection.send_status 'seal'
        agent.execute_method method
      end
    end
  end

  before :each do
    @agent_on_server = Example::Evil::Server.new
    @agent_on_server.setup(:agent_class => 'Example::Evil::Agent',
                           :agent_file  => File.expand_path(File.dirname(__FILE__) + '/../example/evil/agent'))
    @server = Example::TestServer.new
  end

  it "server should receive an answer for say hello" do
    @agent_on_server.should_receive(:received_message).with('hello').once
    execute_method :say_hello
  end

  # Testing Process RLimits only work on a Linux box, not on OS X
  # this should run on Travis
  if RUBY_PLATFORM =~ /linux/

    it "server should receive an exception if agent tries to eat all cpu time" do
      #@agent_on_server.should_receive(:receive_exception).with('', '')
      execute_method :eat_cpu
    end

    it "server should receive an exception if agent tries to eat all cpu time in a subprocess" do
      @agent_on_server.should_receive(:receive_exception).with('SecurityError', "Insecure operation `fork' at level 3")
      execute_method :fork_and_eat
    end

    it "server should receive an exception if agent tries to eat all memory" do
      #@agent_on_server.should_receive(:receive_exception).with('', '')
      execute_method :eat_memory
    end

  end

  it "agent should not be able to read ENV" do
    @agent_on_server.should_receive(:received_message).with("{}").once
    execute_method  :read_env
  end

  it "agent should not be able to read the load path" do
    @agent_on_server.should_receive(:received_message).with([]).once
    execute_method :read_load_path
  end

  it "agent should not be able to read the load path" do
    @agent_on_server.should_receive(:received_message).with([]).once
    execute_method :read_load_path2
  end

  it "agent should not be able to require std libraries" do
    lambda { execute_method(:require_std_lib) }.should raise_error(Exception, "SecurityError: Insecure operation - require")
  end

  it "agent should not be able to read passwords" do
    lambda { execute_method(:steal_passwords) }.should raise_error(Exception, "SecurityError: Insecure operation - read")
  end

  it "agent should not be able to kill the process" do
    @agent_on_server.should_not_receive(:exit)
    @agent_on_server.should_receive(:received_message).never
    execute_method :kill_process
  end

  it "agent should not be able to kill the process over send" do
    @agent_on_server.should_not_receive(:exit)
    lambda { execute_method :send_evil_stuff }.should raise_error(Exception, "client sent unallowed message exit")
  end

  it "agent should not be able to get current path" do
    pending
    @agent_on_server.should_receive(:received_message).with(nil).once
    execute_method :me
  end

  it "agent should not be able to pollute namspaces" do
    lambda { execute_method :pollute_namespace }.should raise_error(Exception, "SecurityError: Insecure operation - class_eval")
  end

  it "agent should not be able to access stdin" do
    pending
    @agent_on_server.should_receive(:received_message).with(nil).once
    execute_method :access_stdin
  end

  # Don't know how, but just suppose it happened
  describe "evil messages" do

    it "should ignore message to kill the server process" do
      @agent_on_server.should_receive(:receive_unallowed_message).with('exit')
      @agent_on_server.should_not_receive(:exit)
      @server.start do |server|
        server.start_agent(@agent_on_server) do |agent|
          agent.connection.receive_object "message"=>"exit", "arguments"=>[]
          server.stop
        end
      end
    end
  end

end
