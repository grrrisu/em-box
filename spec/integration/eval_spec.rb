require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "eval", :focus => true do

  before :each do
    @agent_on_server = Example::Eval::ServerSide.new
    @agent_on_server.setup(:agent_class => 'Example::Eval::Agent',
                           :agent_file  => File.expand_path(File.dirname(__FILE__) + '/../example/eval/agent'))
    @server = EMBox::Server.new
  end

  it "should eval code" do
    @agent_on_server.should_receive(:received_message).with('hello world')
    @server.start do |server|
      server.start_agent(@agent_on_server) do |agent|
        agent.eval_code "'hello world'"
      end
    end
    puts 'end sever start in spec'
  end

end
