# -*- encoding: utf-8 -*-
# stub: rspec-retry 0.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rspec-retry"
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Yusuke Mito"]
  s.date = "2014-03-23"
  s.description = "retry randomly failing example"
  s.email = ["y310.1984@gmail.com"]
  s.homepage = "http://github.com/y310/rspec-retry"
  s.rubygems_version = "2.4.5"
  s.summary = "retry randomly failing example"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<guard-rspec>, [">= 0"])
      s.add_development_dependency(%q<pry-debugger>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<guard-rspec>, [">= 0"])
      s.add_dependency(%q<pry-debugger>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<guard-rspec>, [">= 0"])
    s.add_dependency(%q<pry-debugger>, [">= 0"])
  end
end
