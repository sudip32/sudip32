# -*- encoding: utf-8 -*-
# stub: lazy_high_charts 1.5.4 ruby lib

Gem::Specification.new do |s|
  s.name = "lazy_high_charts"
  s.version = "1.5.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Miguel Michelson", "Deshi Xiao"]
  s.date = "2014-05-22"
  s.description = "    lazy_high_charts is leading edge rubyist render charts gem for displaying Highcharts graphs.\n"
  s.email = ["miguelmichelson@gmail.com", "xiaods@gmail.com"]
  s.extra_rdoc_files = ["README.md", "CHANGELOG.md"]
  s.files = ["CHANGELOG.md", "README.md"]
  s.homepage = "https://github.com/michelson/lazy_high_charts"
  s.rdoc_options = ["--charset=UTF-8"]
  s.rubygems_version = "2.4.5"
  s.summary = "rubyist way to render variant chart by highcharts without write javascript right now, rails gem library."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bundler>, [">= 1.0"])
      s.add_runtime_dependency(%q<hash-deep-merge>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, [">= 1.0"])
      s.add_dependency(%q<hash-deep-merge>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, [">= 1.0"])
    s.add_dependency(%q<hash-deep-merge>, [">= 0"])
  end
end
