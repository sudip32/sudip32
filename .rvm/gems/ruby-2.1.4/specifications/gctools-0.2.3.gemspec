# -*- encoding: utf-8 -*-
# stub: gctools 0.2.3 ruby lib
# stub: ext/gcprof/extconf.rb ext/oobgc/extconf.rb

Gem::Specification.new do |s|
  s.name = "gctools"
  s.version = "0.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Aman Gupta"]
  s.date = "2014-01-30"
  s.description = "gc debugger, logger and profiler for rgengc in ruby 2.1"
  s.email = "aman@tmm1.net"
  s.extensions = ["ext/gcprof/extconf.rb", "ext/oobgc/extconf.rb"]
  s.files = ["ext/gcprof/extconf.rb", "ext/oobgc/extconf.rb"]
  s.homepage = "https://github.com/tmm1/gctools"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "rgengc tools for ruby 2.1+"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake-compiler>, ["~> 0.9"])
    else
      s.add_dependency(%q<rake-compiler>, ["~> 0.9"])
    end
  else
    s.add_dependency(%q<rake-compiler>, ["~> 0.9"])
  end
end
