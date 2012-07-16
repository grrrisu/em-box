require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Echo" do

  before :each do
    @agent_on_server = Example::Echo::Server.new(:agent_class => 'Example::Echo::Agent',
                        :agent_file  => File.expand_path(File.dirname(__FILE__) + '/../example/echo/agent'))
  end

  describe "without return value" do

    before :each do
      @server = EMBox::Server.new [@agent_on_server]
    end

    it "server should receive an echo", :focus => true do
      @agent_on_server.should_receive(:received_message).with('client: hello from server').twice
      @server.start do |server|
        server.start_all_agents do
          2.times { @agent_on_server.says('hello from server') }
        end
      end
      puts 'end sever start in spec'
    end

  end

  describe "with return values" do

    before :each do
      @server = EMBox::Server.new [@agent_on_server], :client_class => 'EMBox::Client::SynchronizedClient'
    end

    it "server should receive an echo" do
      @agent_on_server.should_receive(:received_message).with('client is thinking').once
      @agent_on_server.should_receive(:received_message).with('server echo: client is thinking').once

      @server.start do |server|
        server.start_all_agents do
          @server.broadcast :start
        end
      end
    end

  end

  describe "with 3 agents and return values" do

    before :each do
      @agent_on_server2 = @agent_on_server.clone
      @agent_on_server3 = @agent_on_server.clone
      @server = EMBox::Server.new [@agent_on_server, @agent_on_server2, @agent_on_server3],
                                  :client_class => 'EMBox::Client::SynchronizedClient'
    end

    it "server should receive an echo" do
      [@agent_on_server, @agent_on_server2, @agent_on_server3].each do |agent_on_server|
        agent_on_server.should_receive(:received_message).with('client is thinking').once
        agent_on_server.should_receive(:received_message).with('server echo: client is thinking').once
      end
      @server.start do |server|
        server.start_all_agents do
          @server.broadcast :start
        end
      end
    end

  end
end
