# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "em-box"
  s.version = ""

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alessandro Di Maria"]
  s.date = "2012-07-03"
  s.description = "TODO: longer description of your gem"
  s.email = "adm@m42.ch"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.markdown"
  ]
  s.files = [
    ".document",
    ".rspec",
    ".rvmrc",
    ".travis.yml",
    "Gemfile",
    "Gemfile.lock",
    "Guardfile",
    "LICENSE.txt",
    "README.markdown",
    "Rakefile",
    "VERSION",
    "lib/em-box/client/agent.rb",
    "lib/em-box/client/base.rb",
    "lib/em-box/client/server_connection.rb",
    "lib/em-box/client/synchronized_client.rb",
    "lib/em-box/client_connection.rb",
    "lib/em-box/has_client.rb",
    "lib/em-box/has_connection.rb",
    "lib/em-box/sandbox/base.rb",
    "lib/em-box/sandbox/default_config.json",
    "lib/em-box/server.rb",
    "lib/em_box.rb",
    "spec/example/echo/agent.rb",
    "spec/example/echo/client_config.json",
    "spec/example/echo/server.rb",
    "spec/example/evil/agent.rb",
    "spec/example/evil/sever.rb",
    "spec/example/simple_agent.rb",
    "spec/example/simple_agent_capability.rb",
    "spec/example/simple_agent_client.rb",
    "spec/example/simple_agent_server.rb",
    "spec/integration/echo_spec.rb",
    "spec/integration/evil_spec.rb",
    "spec/integration/simple_agent_specx.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/grrrisu/em-box"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "TODO: one-line summary of your gem"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<eventmachine>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<guard>, [">= 0"])
      s.add_development_dependency(%q<guard-rspec>, [">= 0"])
      s.add_development_dependency(%q<growl>, [">= 0"])
    else
      s.add_dependency(%q<eventmachine>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<guard>, [">= 0"])
      s.add_dependency(%q<guard-rspec>, [">= 0"])
      s.add_dependency(%q<growl>, [">= 0"])
    end
  else
    s.add_dependency(%q<eventmachine>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<guard>, [">= 0"])
    s.add_dependency(%q<guard-rspec>, [">= 0"])
    s.add_dependency(%q<growl>, [">= 0"])
  end
end

