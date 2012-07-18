require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "eval" do

  before :each do
    @agent_on_server = Example::Eval::ServerSide.new
    @agent_on_server.setup(:agent_class => 'Example::Eval::Agent',
                           :agent_file  => File.expand_path(File.dirname(__FILE__) + '/../example/eval/agent'))
    @server = Example::TestServer.new
  end

  it "should eval code" do
    @agent_on_server.should_receive(:received_message).with('hello world')
    @server.stop_after = 1

    @server.start do |server|
      server.start_agent(@agent_on_server) do |agent|
        agent.eval_code "'hello world'"
      end
    end
    puts 'end sever start in spec'
  end

  it "should eval code for more agents" do
    @agent_on_server2 = Example::Eval::ServerSide.new
    @agent_on_server2.setup(:agent_class => 'Example::Eval::Agent',
                           :agent_file  => File.expand_path(File.dirname(__FILE__) + '/../example/eval/agent'))

    @agent_on_server.should_receive(:received_message).with('hello world')
    @agent_on_server2.should_receive(:received_message).with('hello moon')
    @server.stop_after = 2

    @server.start do |server|
      server.start_agent(@agent_on_server) do |agent|
        agent.eval_code "'hello world'"
      end
      server.start_agent(@agent_on_server2) do |agent|
        agent.eval_code "'hello moon'"
      end
    end
  end

  it "should eval code within sandbox" do
    @agent_on_server.should_receive(:received_message).with('hello world').never
    @server.stop_after = 1

    lambda {
      @server.start do |server|
        server.start_agent(@agent_on_server) do |agent|
            agent.eval_code_within_sandbox "::Object.new.instance_eval('hello world')"
        end
      end
    }.should raise_error(Exception, "SecurityError: Insecure operation - instance_eval")
    puts 'end sever start in spec'
  end

  it "should eval code within sandbox" do
    @agent_on_server.should_receive(:received_message).with('hello world').once
    @server.stop_after = 1

    @server.start do |server|
      server.start_agent(@agent_on_server) do |agent|
        agent.eval_code_within_sandbox '"hello world"'
      end
    end
    puts 'end sever start in spec'
  end

end
