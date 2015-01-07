# -*- encoding: utf-8 -*-
# stub: honeybadger 1.16.6 ruby lib

Gem::Specification.new do |s|
  s.name = "honeybadger"
  s.version = "1.16.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Joshua Wood"]
  s.date = "2014-11-26"
  s.description = "Make managing application errors a more pleasant experience."
  s.email = "josh@honeybadger.io"
  s.extra_rdoc_files = ["README.md", "MIT-LICENSE"]
  s.files = ["MIT-LICENSE", "README.md"]
  s.homepage = "http://www.honeybadger.io"
  s.rdoc_options = ["--charset=UTF-8", "--markup tomdoc"]
  s.rubygems_version = "2.4.5"
  s.summary = "Error reports you can be happy about."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<cucumber>, ["~> 1.3.10"])
      s.add_development_dependency(%q<rspec>, ["~> 2.14.0"])
      s.add_development_dependency(%q<sham_rack>, ["~> 1.3.0"])
      s.add_development_dependency(%q<capistrano>, ["~> 2.0"])
      s.add_development_dependency(%q<guard>, ["~> 1.8.3"])
      s.add_development_dependency(%q<guard-rspec>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<sinatra>, [">= 0"])
      s.add_development_dependency(%q<aruba>, [">= 0"])
      s.add_development_dependency(%q<appraisal>, [">= 0"])
      s.add_development_dependency(%q<fuubar>, [">= 0"])
      s.add_development_dependency(%q<growl>, [">= 0"])
    else
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<cucumber>, ["~> 1.3.10"])
      s.add_dependency(%q<rspec>, ["~> 2.14.0"])
      s.add_dependency(%q<sham_rack>, ["~> 1.3.0"])
      s.add_dependency(%q<capistrano>, ["~> 2.0"])
      s.add_dependency(%q<guard>, ["~> 1.8.3"])
      s.add_dependency(%q<guard-rspec>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<sinatra>, [">= 0"])
      s.add_dependency(%q<aruba>, [">= 0"])
      s.add_dependency(%q<appraisal>, [">= 0"])
      s.add_dependency(%q<fuubar>, [">= 0"])
      s.add_dependency(%q<growl>, [">= 0"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<cucumber>, ["~> 1.3.10"])
    s.add_dependency(%q<rspec>, ["~> 2.14.0"])
    s.add_dependency(%q<sham_rack>, ["~> 1.3.0"])
    s.add_dependency(%q<capistrano>, ["~> 2.0"])
    s.add_dependency(%q<guard>, ["~> 1.8.3"])
    s.add_dependency(%q<guard-rspec>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<sinatra>, [">= 0"])
    s.add_dependency(%q<aruba>, [">= 0"])
    s.add_dependency(%q<appraisal>, [">= 0"])
    s.add_dependency(%q<fuubar>, [">= 0"])
    s.add_dependency(%q<growl>, [">= 0"])
  end
end
