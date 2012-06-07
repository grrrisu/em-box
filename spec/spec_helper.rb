require File.expand_path(File.dirname(__FILE__) + '/../lib/em_box')

RSpec.configure do |config|
  config.mock_with :rspec

  config.fail_fast = true

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end

# require helper files
Dir["#{File.dirname(__FILE__)}/example/*.rb"].uniq.each do |file|
  require file
end