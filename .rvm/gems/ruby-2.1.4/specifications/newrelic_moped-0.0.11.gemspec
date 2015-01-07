# -*- encoding: utf-8 -*-
# stub: newrelic_moped 0.0.11 ruby lib

Gem::Specification.new do |s|
  s.name = "newrelic_moped"
  s.version = "0.0.11"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Stephen Bartholomew", "Piotr Sokolowski"]
  s.date = "2014-05-08"
  s.description = "New Relic Instrumentation for Moped & Mongoid 3"
  s.email = ["stephenbartholomew@gmail.com"]
  s.homepage = "https://github.com/stevebartholomew/newrelic_moped"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "New Relic Instrumentation for Moped & Mongoid 3"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<newrelic_rpm>, [">= 3.7", "~> 3.0"])
      s.add_runtime_dependency(%q<moped>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<newrelic_rpm>, [">= 3.7", "~> 3.0"])
      s.add_dependency(%q<moped>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<newrelic_rpm>, [">= 3.7", "~> 3.0"])
    s.add_dependency(%q<moped>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
