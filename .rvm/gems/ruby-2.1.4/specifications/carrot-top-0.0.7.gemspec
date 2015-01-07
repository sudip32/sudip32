# -*- encoding: utf-8 -*-
# stub: carrot-top 0.0.7 ruby lib

Gem::Specification.new do |s|
  s.name = "carrot-top"
  s.version = "0.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Sean Porter"]
  s.date = "2012-12-25"
  s.description = "A Ruby library for querying the RabbitMQ Management API, `top` for RabbitMQ."
  s.email = ["portertech@gmail.com"]
  s.homepage = "https://github.com/portertech/carrot-top"
  s.rubyforge_project = "carrot-top"
  s.rubygems_version = "2.4.5"
  s.summary = "A Ruby library for querying the RabbitMQ Management API"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
    else
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
  end
end
