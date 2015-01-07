# -*- encoding: utf-8 -*-
# stub: capistrano-team_notifications 3.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "capistrano-team_notifications"
  s.version = "3.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Alexander Balashov"]
  s.date = "2014-04-24"
  s.email = ["divineforest@example.com"]
  s.homepage = "https://github.com/evrone/capistrano-team_notifications"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "Capistrano notifications for all team members via OSX Notification Center"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capistrano>, ["~> 3.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<capistrano>, ["~> 3.0"])
      s.add_dependency(%q<bundler>, ["~> 1"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<capistrano>, ["~> 3.0"])
    s.add_dependency(%q<bundler>, ["~> 1"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
