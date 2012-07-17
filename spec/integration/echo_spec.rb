require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Echo" do

  before :each do
    @agent_on_server = Example::Echo::Server.new
    @agent_on_server.setup(:agent_class => 'Example::Echo::Agent',
                           :agent_file  => File.expand_path(File.dirname(__FILE__) + '/../example/echo/agent'))
  end

  describe "without return value" do

    before :each do
      @server = Example::TestServer.new
    end

    it "server should receive an echo" do
      @agent_on_server.should_receive(:received_message).with('client: hello from server').twice
      @server.start do |server|
        server.start_agent(@agent_on_server) do |agent|
          2.times { agent.says('hello from server') }
        end
      end
      puts 'end sever start in spec'
    end

  end

  describe "with return values" do

    before :each do
      @server = Example::TestServer.new :client_class => 'EMBox::Client::SynchronizedClient'
    end

    it "server should receive an echo" do
      @agent_on_server.should_receive(:received_message).with('client is thinking').once
      @agent_on_server.should_receive(:received_message).with('server echo: client is thinking').once
      @server.stop_after = 2

      @server.start do |server|
        server.start_agent(@agent_on_server) do |agent|
          agent.connection.send_status :start
        end
      end
    end

  end

  describe "with 3 agents and return values" do

    before :each do
      @agent_on_server2 = @agent_on_server.clone
      @agent_on_server3 = @agent_on_server.clone
      @server = Example::TestServer.new :client_class => 'EMBox::Client::SynchronizedClient'
    end

    it "server should receive an echo" do
      [@agent_on_server, @agent_on_server2, @agent_on_server3].each do |agent_on_server|
        agent_on_server.should_receive(:received_message).with('client is thinking').once
        agent_on_server.should_receive(:received_message).with('server echo: client is thinking').once
      end
      @server.stop_after = 6

      @server.start do |server|
        [@agent_on_server, @agent_on_server2, @agent_on_server3].each do |agent_on_server|
          server.start_agent(agent_on_server) do |agent|
            agent.connection.send_status :start
          end
        end

      end
    end

  end
end
