# -*- encoding: utf-8 -*-
# stub: partialruby 0.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "partialruby"
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Dario Seminara"]
  s.date = "2013-11-17"
  s.email = "robertodarioseminara@gmail.com"
  s.extra_rdoc_files = ["README"]
  s.files = ["README"]
  s.homepage = "http://github.com/tario/partialruby"
  s.rdoc_options = ["--main", "README"]
  s.rubygems_version = "2.4.5"
  s.summary = "Ruby partial interpreter written in pure-ruby"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruby_parser>, ["~> 3"])
      s.add_runtime_dependency(%q<ruby2ruby>, ["~> 2"])
    else
      s.add_dependency(%q<ruby_parser>, ["~> 3"])
      s.add_dependency(%q<ruby2ruby>, ["~> 2"])
    end
  else
    s.add_dependency(%q<ruby_parser>, ["~> 3"])
    s.add_dependency(%q<ruby2ruby>, ["~> 2"])
  end
end
