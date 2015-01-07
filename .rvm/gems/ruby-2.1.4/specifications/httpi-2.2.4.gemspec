# -*- encoding: utf-8 -*-
# stub: httpi 2.2.4 ruby lib

Gem::Specification.new do |s|
  s.name = "httpi"
  s.version = "2.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Daniel Harrington", "Martin Tepper"]
  s.date = "2014-06-26"
  s.description = "Common interface for Ruby's HTTP libraries"
  s.email = "me@rubiii.com"
  s.homepage = "http://github.com/savonrb/\#{s.name}"
  s.licenses = ["MIT"]
  s.rubyforge_project = "httpi"
  s.rubygems_version = "2.4.5"
  s.summary = "Common interface for Ruby's HTTP libraries"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0"])
      s.add_development_dependency(%q<rubyntlm>, ["~> 0.3.2"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.14"])
      s.add_development_dependency(%q<mocha>, ["~> 0.13"])
      s.add_development_dependency(%q<puma>, ["~> 2.3.2"])
    else
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<rubyntlm>, ["~> 0.3.2"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<rspec>, ["~> 2.14"])
      s.add_dependency(%q<mocha>, ["~> 0.13"])
      s.add_dependency(%q<puma>, ["~> 2.3.2"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<rubyntlm>, ["~> 0.3.2"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<rspec>, ["~> 2.14"])
    s.add_dependency(%q<mocha>, ["~> 0.13"])
    s.add_dependency(%q<puma>, ["~> 2.3.2"])
  end
end
