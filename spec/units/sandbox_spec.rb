require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EMBox::Sandbox::Base do
  
  before :each do
    config_file = File.expand_path(File.dirname(__FILE__) + '/../example/echo/client_config.json')
    @sandbox = EMBox::Sandbox::Base.new(config_file)
  end
  
  it "should read config file" do
    @sandbox.seal
    lambda{ fork {loop {} } }.should raise_error(Exception)
  end
  
end