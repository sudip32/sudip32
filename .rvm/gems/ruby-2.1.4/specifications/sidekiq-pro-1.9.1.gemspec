# -*- encoding: utf-8 -*-
# stub: sidekiq-pro 1.9.1 ruby lib

Gem::Specification.new do |s|
  s.name = "sidekiq-pro"
  s.version = "1.9.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Mike Perham"]
  s.date = "2014-10-14"
  s.description = "Loads of additional functionality for Sidekiq"
  s.email = ["mperham@gmail.com"]
  s.homepage = "http://sidekiq.org"
  s.licenses = ["Commercial"]
  s.rubygems_version = "2.4.5"
  s.summary = "Black belt functionality for Sidekiq"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sidekiq>, [">= 3.2.3"])
    else
      s.add_dependency(%q<sidekiq>, [">= 3.2.3"])
    end
  else
    s.add_dependency(%q<sidekiq>, [">= 3.2.3"])
  end
end
