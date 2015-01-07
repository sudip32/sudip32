# -*- encoding: utf-8 -*-
# stub: ripper_ruby_parser 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "ripper_ruby_parser"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Matijs van Zuijlen"]
  s.date = "2014-02-07"
  s.description = "    RipperRubyParser is a parser for Ruby based on Ripper that aims to be a\n    drop-in replacement for RubyParser.\n"
  s.email = ["matijs@matijs.net"]
  s.extra_rdoc_files = ["README.md"]
  s.files = ["README.md"]
  s.homepage = "http://www.github.com/mvz/ripper_ruby_parser"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--main", "README.md"]
  s.rubygems_version = "2.4.5"
  s.summary = "Parse with Ripper, produce sexps that are compatible with RubyParser."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sexp_processor>, ["~> 4.4.1"])
      s.add_development_dependency(%q<minitest>, ["~> 5.2"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<ruby_parser>, ["~> 3.3.0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
    else
      s.add_dependency(%q<sexp_processor>, ["~> 4.4.1"])
      s.add_dependency(%q<minitest>, ["~> 5.2"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<ruby_parser>, ["~> 3.3.0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
    end
  else
    s.add_dependency(%q<sexp_processor>, ["~> 4.4.1"])
    s.add_dependency(%q<minitest>, ["~> 5.2"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<ruby_parser>, ["~> 3.3.0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
  end
end
