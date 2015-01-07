# -*- encoding: utf-8 -*-
# stub: turbo-sprockets-rails3 0.3.14 ruby lib

Gem::Specification.new do |s|
  s.name = "turbo-sprockets-rails3"
  s.version = "0.3.14"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Nathan Broadbent"]
  s.date = "2014-08-05"
  s.description = "Speeds up the Rails 3 asset pipeline by only recompiling changed assets"
  s.email = ["nathan.f77@gmail.com"]
  s.homepage = "https://github.com/ndbroadbent/turbo-sprockets-rails3"
  s.rubygems_version = "2.4.5"
  s.summary = "Supercharge your Rails 3 asset pipeline"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sprockets>, [">= 2.2.0"])
      s.add_runtime_dependency(%q<railties>, ["< 4.0.0", "> 3.2.8"])
      s.add_development_dependency(%q<minitest>, ["~> 2.3.0"])
      s.add_development_dependency(%q<mocha>, ["~> 0.13.3"])
    else
      s.add_dependency(%q<sprockets>, [">= 2.2.0"])
      s.add_dependency(%q<railties>, ["< 4.0.0", "> 3.2.8"])
      s.add_dependency(%q<minitest>, ["~> 2.3.0"])
      s.add_dependency(%q<mocha>, ["~> 0.13.3"])
    end
  else
    s.add_dependency(%q<sprockets>, [">= 2.2.0"])
    s.add_dependency(%q<railties>, ["< 4.0.0", "> 3.2.8"])
    s.add_dependency(%q<minitest>, ["~> 2.3.0"])
    s.add_dependency(%q<mocha>, ["~> 0.13.3"])
  end
end
