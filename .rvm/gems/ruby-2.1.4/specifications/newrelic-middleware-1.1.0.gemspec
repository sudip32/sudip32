# -*- encoding: utf-8 -*-
# stub: newrelic-middleware 1.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "newrelic-middleware"
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["twinturbo"]
  s.date = "2012-05-15"
  s.description = "Track time spent your middleware stack with New Relic"
  s.email = ["me@broadcastingadam.com"]
  s.homepage = "https://github.com/twinturbo/newrelic-middleware"
  s.rubygems_version = "2.4.5"
  s.summary = ""

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<newrelic_rpm>, [">= 0"])
      s.add_development_dependency(%q<rails>, [">= 0"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
    else
      s.add_dependency(%q<newrelic_rpm>, [">= 0"])
      s.add_dependency(%q<rails>, [">= 0"])
      s.add_dependency(%q<rack-test>, [">= 0"])
    end
  else
    s.add_dependency(%q<newrelic_rpm>, [">= 0"])
    s.add_dependency(%q<rails>, [">= 0"])
    s.add_dependency(%q<rack-test>, [">= 0"])
  end
end
