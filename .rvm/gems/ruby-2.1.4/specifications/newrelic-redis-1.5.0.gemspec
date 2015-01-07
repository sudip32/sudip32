# -*- encoding: utf-8 -*-
# stub: newrelic-redis 1.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "newrelic-redis"
  s.version = "1.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Evan Phoenix"]
  s.date = "2014-08-25"
  s.description = "Redis instrumentation for Newrelic."
  s.email = ["evan@phx.io"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt"]
  s.homepage = "http://github.com/evanphx/newrelic-redis"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--main", "README.txt"]
  s.rubygems_version = "2.4.5"
  s.summary = "Redis instrumentation for Newrelic."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<redis>, ["< 4.0"])
      s.add_runtime_dependency(%q<newrelic_rpm>, ["~> 3.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_development_dependency(%q<hoe>, ["~> 3.12"])
    else
      s.add_dependency(%q<redis>, ["< 4.0"])
      s.add_dependency(%q<newrelic_rpm>, ["~> 3.0"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<hoe>, ["~> 3.12"])
    end
  else
    s.add_dependency(%q<redis>, ["< 4.0"])
    s.add_dependency(%q<newrelic_rpm>, ["~> 3.0"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<hoe>, ["~> 3.12"])
  end
end
