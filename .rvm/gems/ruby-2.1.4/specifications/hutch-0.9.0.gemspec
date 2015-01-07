# -*- encoding: utf-8 -*-
# stub: hutch 0.9.0 ruby lib

Gem::Specification.new do |s|
  s.name = "hutch"
  s.version = "0.9.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Harry Marr"]
  s.date = "2014-05-13"
  s.description = "Hutch is a Ruby library for enabling asynchronous inter-service communication using RabbitMQ."
  s.email = ["developers@gocardless.com"]
  s.executables = ["hutch"]
  s.files = ["bin/hutch"]
  s.homepage = "https://github.com/gocardless/hutch"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "Easy inter-service communication using RabbitMQ."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bunny>, ["~> 1.2.1"])
      s.add_runtime_dependency(%q<carrot-top>, ["~> 0.0.7"])
      s.add_runtime_dependency(%q<multi_json>, ["~> 1.5"])
      s.add_development_dependency(%q<rspec>, ["~> 2.12.0"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.7.1"])
    else
      s.add_dependency(%q<bunny>, ["~> 1.2.1"])
      s.add_dependency(%q<carrot-top>, ["~> 0.0.7"])
      s.add_dependency(%q<multi_json>, ["~> 1.5"])
      s.add_dependency(%q<rspec>, ["~> 2.12.0"])
      s.add_dependency(%q<simplecov>, ["~> 0.7.1"])
    end
  else
    s.add_dependency(%q<bunny>, ["~> 1.2.1"])
    s.add_dependency(%q<carrot-top>, ["~> 0.0.7"])
    s.add_dependency(%q<multi_json>, ["~> 1.5"])
    s.add_dependency(%q<rspec>, ["~> 2.12.0"])
    s.add_dependency(%q<simplecov>, ["~> 0.7.1"])
  end
end
