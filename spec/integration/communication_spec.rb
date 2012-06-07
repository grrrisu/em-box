require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Communication" do

  before :each do
    @agent_on_server = Example::EchoServer.new(:client_class => 'Example::EchoClient',
                                               :client_file => File.expand_path(File.dirname(__FILE__) + '/../example/echo_client'))
    @server = EMBox::Server.new [@agent_on_server]
  end


  it "server should receive an echo" do
    @agent_on_server.should_receive(:echo).with('client: hello from server')
    @server.start do
      @agent_on_server.says('hello from server')
    end
  end

end