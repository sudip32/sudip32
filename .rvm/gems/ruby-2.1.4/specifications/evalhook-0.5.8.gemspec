# -*- encoding: utf-8 -*-
# stub: evalhook 0.5.8 ruby lib

Gem::Specification.new do |s|
  s.name = "evalhook"
  s.version = "0.5.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Dario Seminara"]
  s.date = "2014-01-22"
  s.email = "robertodarioseminara@gmail.com"
  s.extra_rdoc_files = ["README"]
  s.files = ["README"]
  s.homepage = "http://github.com/tario/evalhook"
  s.rdoc_options = ["--main", "README"]
  s.rubygems_version = "2.4.5"
  s.summary = "Alternate eval which hook all methods executed in the evaluated code"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<partialruby>, ["~> 0.3"])
      s.add_runtime_dependency(%q<sexp_processor>, ["~> 4.0"])
    else
      s.add_dependency(%q<partialruby>, ["~> 0.3"])
      s.add_dependency(%q<sexp_processor>, ["~> 4.0"])
    end
  else
    s.add_dependency(%q<partialruby>, ["~> 0.3"])
    s.add_dependency(%q<sexp_processor>, ["~> 4.0"])
  end
end
