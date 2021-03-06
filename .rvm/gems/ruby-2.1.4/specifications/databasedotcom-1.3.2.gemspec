# -*- encoding: utf-8 -*-
# stub: databasedotcom 1.3.2 ruby lib

Gem::Specification.new do |s|
  s.name = "databasedotcom"
  s.version = "1.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Glenn Gillen, Danny Burkes & Richard Zhao"]
  s.date = "2012-12-27"
  s.description = "A ruby wrapper for the Force.com REST API"
  s.email = ["me@glenngillen.com"]
  s.homepage = "https://github.com/heroku/databasedotcom"
  s.rubyforge_project = "databasedotcom"
  s.rubygems_version = "2.4.5"
  s.summary = "A ruby wrapper for the Force.com REST API"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<multipart-post>, ["~> 1.1"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0.8.6"])
    else
      s.add_dependency(%q<multipart-post>, ["~> 1.1"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.6"])
      s.add_dependency(%q<webmock>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0.8.6"])
    end
  else
    s.add_dependency(%q<multipart-post>, ["~> 1.1"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.6"])
    s.add_dependency(%q<webmock>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0.8.6"])
  end
end
