# -*- encoding: utf-8 -*-
# stub: progressbar 0.21.0 ruby lib

Gem::Specification.new do |s|
  s.name = "progressbar"
  s.version = "0.21.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Satoru Takabayashi", "Jose Peleteiro"]
  s.date = "2013-09-13"
  s.description = "Ruby/ProgressBar is a text progress bar library for Ruby. It can indicate progress with percentage, a progress bar, and estimated remaining time."
  s.email = ["satoru@0xcc.net", "jose@peleteiro.net"]
  s.homepage = "http://github.com/peleteiro/progressbar"
  s.licenses = ["Ruby"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.rubygems_version = "2.4.5"
  s.summary = "Ruby/ProgressBar is a text progress bar library for Ruby."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0.3.5"])
      s.add_development_dependency(%q<bluecloth>, [">= 0.3.5"])
    else
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0.3.5"])
      s.add_dependency(%q<bluecloth>, [">= 0.3.5"])
    end
  else
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0.3.5"])
    s.add_dependency(%q<bluecloth>, [">= 0.3.5"])
  end
end
