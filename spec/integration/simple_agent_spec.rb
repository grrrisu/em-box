require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "SimpleAgent" do

  before :each do
    @agent_on_server = Example::SimpleAgentServer.new(:client_class => 'Example::SimpleAgentClient',
                                                      :client_file => File.expand_path(File.dirname(__FILE__) + '/../example/simple_agent_client'))
    @server = EMBox::Server.new [@agent_on_server]
  end

  it "server should receive client commands" do
    @agent_on_server.should_receive(:look_around).twice.and_return([{x:0,y:0,population:450}])
    @agent_on_server.should_receive(:move_to).with([1,0]).twice.and_return([1,0])
    @server.start do
      @agent_on_server.start_game
    end
  end

end