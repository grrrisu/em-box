require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Evil" do

  before :each do
    @agent_on_server = Example::Evil::Server.new(:agent_class => 'Example::Evil::Agent',
                        :agent_file  => File.expand_path(File.dirname(__FILE__) + '/../example/evil/agent'))
    @server = EMBox::Server.new [@agent_on_server]
  end

  it "server should receive an answer for say hello" do
    @agent_on_server.should_receive(:received_message).with('hello').once
    @server.start do
      @agent_on_server.connection.send_status 'seal'
      @agent_on_server.execute_method :say_hello
    end
  end

  # Testing Process RLimits only work on a Linux box, not on OS X
  # this should run on Travis
  if RUBY_PLATFORM =~ /linux/

    it "server should receive an exception if agent tries to eat all cpu time" do
      #@agent_on_server.should_receive(:receive_exception).with('', '')
      @server.start do
        @agent_on_server.connection.send_status 'seal'
        @agent_on_server.execute_method :eat_cpu
      end
    end

    it "server should receive an exception if agent tries to eat all cpu time in a subprocess" do
      @agent_on_server.should_receive(:receive_exception).with('SecurityError', "Insecure operation `fork' at level 3")
      @server.start do
        @agent_on_server.connection.send_status 'seal'
        @agent_on_server.execute_method :fork_and_eat
      end
    end

    it "server should receive an exception if agent tries to eat all memory" do
      #@agent_on_server.should_receive(:receive_exception).with('', '')
      @server.start do
        @agent_on_server.connection.send_status 'seal'
        @agent_on_server.execute_method :eat_memory
      end
    end

  end

  it "agent should not be able to read ENV" do
    @agent_on_server.should_receive(:received_message).with("{}").once
    @server.start do
      @agent_on_server.connection.send_status 'seal'
      @agent_on_server.execute_method :read_env
    end
  end

  it "agent should not be able to read the load path" do
    @agent_on_server.should_receive(:received_message).with([]).once
    @server.start do
      @agent_on_server.connection.send_status 'seal'
      @agent_on_server.execute_method :read_load_path
    end
  end
  
  it "agent should not be able to read the load path" do
    @agent_on_server.should_receive(:received_message).with([]).once
    @server.start do
      @agent_on_server.connection.send_status 'seal'
      @agent_on_server.execute_method :read_load_path2
    end
  end
  
  it "agent should not be able to require std libraries" do
    @agent_on_server.should_receive(:receive_exception).with('SecurityError', 'Insecure operation - require')
      @server.start do
        @agent_on_server.connection.send_status 'seal'
        @agent_on_server.execute_method :require_std_lib
      end
  end
  
  it "agent should not be able to read passwords" do
    @agent_on_server.should_receive(:receive_exception).with('SecurityError', 'Insecure operation - read')
    @server.start do
      @agent_on_server.connection.send_status 'seal'
      @agent_on_server.execute_method :steal_passwords
    end
  end

  it "agent should not be able to kill the process" do
    @agent_on_server.should_not_receive(:exit)
    @agent_on_server.should_receive(:received_message).never
    @server.start do
      @agent_on_server.connection.send_status 'seal'
      @agent_on_server.execute_method :kill_process
    end
  end

  it "agent should not be able to kill the process over send" do
    @server.should_receive(:unallowed_method).with(anything,:exit)
    @agent_on_server.should_not_receive(:exit)
    @agent_on_server.should_receive(:received_message).with(anything)
    @server.start do
      @agent_on_server.connection.send_status 'seal'
      @agent_on_server.execute_method :send_evil_stuff
    end
  end

  it "agent should not be able to get current path" do
    pending
    @agent_on_server.should_receive(:received_message).with(nil).once
    @server.start do
      @agent_on_server.connection.send_status 'seal'
      @agent_on_server.execute_method :me
    end
  end

  it "agent should not be able to pollute namspaces" do
    @agent_on_server.should_receive(:receive_exception).with('SecurityError', 'Insecure operation - class_eval')
    @server.start do
      @agent_on_server.connection.send_status 'seal'
      @agent_on_server.execute_method :pollute_namespace
    end
  end

  it "agent should not be able to access stdin" do
    pending
    @agent_on_server.should_receive(:received_message).with(nil).once
    @server.start do
      @agent_on_server.connection.send_status 'seal'
      @agent_on_server.execute_method :access_stdin
    end
  end
  
  # Don't know how, but just suppose they happen
  describe "evil messages" do
    
    it "should ignore message to kill the server process" do
      @server.should_receive(:unallowed_method).with(anything,:exit)
      @agent_on_server.should_not_receive(:exit)
      @server.start do
        @agent_on_server.connection.receive_object "message"=>"exit", "arguments"=>[]
      end
    end
  end
  

end
