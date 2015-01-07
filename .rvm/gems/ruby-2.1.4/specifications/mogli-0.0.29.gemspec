# -*- encoding: utf-8 -*-
# stub: mogli 0.0.29 ruby lib

Gem::Specification.new do |s|
  s.name = "mogli"
  s.version = "0.0.29"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Mike Mangino"]
  s.date = "2011-07-28"
  s.description = "Simple library for accessing the facebook Open Graph API"
  s.email = "mmangino@elevatedrails.com"
  s.homepage = "http://developers.facebook.com/docs/api"
  s.rubygems_version = "2.4.5"
  s.summary = "Open Graph Library for Ruby"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, [">= 0.4.3"])
      s.add_runtime_dependency(%q<hashie>, ["~> 1.0.0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<httparty>, [">= 0.4.3"])
      s.add_dependency(%q<hashie>, ["~> 1.0.0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<httparty>, [">= 0.4.3"])
    s.add_dependency(%q<hashie>, ["~> 1.0.0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
