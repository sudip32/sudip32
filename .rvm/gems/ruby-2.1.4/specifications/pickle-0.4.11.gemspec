# -*- encoding: utf-8 -*-
# stub: pickle 0.4.11 ruby lib

Gem::Specification.new do |s|
  s.name = "pickle"
  s.version = "0.4.11"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Ian White"]
  s.date = "2012-07-06"
  s.description = "Easy model creation and reference in your cucumber features"
  s.email = "ian.w.white@gmail.com"
  s.homepage = "http://github.com/ianwhite/pickle"
  s.rubyforge_project = "pickle"
  s.rubygems_version = "2.4.5"
  s.summary = "Easy model creation and reference in your cucumber features."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cucumber>, [">= 0.8"])
      s.add_runtime_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rack>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<git>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 2.6.0"])
      s.add_development_dependency(%q<rails>, ["~> 3.1.0"])
      s.add_development_dependency(%q<cucumber-rails>, [">= 0"])
      s.add_development_dependency(%q<factory_girl>, [">= 0"])
      s.add_development_dependency(%q<fabrication>, [">= 0"])
      s.add_development_dependency(%q<machinist>, [">= 0"])
      s.add_development_dependency(%q<database_cleaner>, [">= 0"])
      s.add_development_dependency(%q<capybara>, [">= 0"])
      s.add_development_dependency(%q<sqlite3-ruby>, [">= 0"])
    else
      s.add_dependency(%q<cucumber>, [">= 0.8"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<git>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<rspec-rails>, ["~> 2.6.0"])
      s.add_dependency(%q<rails>, ["~> 3.1.0"])
      s.add_dependency(%q<cucumber-rails>, [">= 0"])
      s.add_dependency(%q<factory_girl>, [">= 0"])
      s.add_dependency(%q<fabrication>, [">= 0"])
      s.add_dependency(%q<machinist>, [">= 0"])
      s.add_dependency(%q<database_cleaner>, [">= 0"])
      s.add_dependency(%q<capybara>, [">= 0"])
      s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
    end
  else
    s.add_dependency(%q<cucumber>, [">= 0.8"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<git>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<rspec-rails>, ["~> 2.6.0"])
    s.add_dependency(%q<rails>, ["~> 3.1.0"])
    s.add_dependency(%q<cucumber-rails>, [">= 0"])
    s.add_dependency(%q<factory_girl>, [">= 0"])
    s.add_dependency(%q<fabrication>, [">= 0"])
    s.add_dependency(%q<machinist>, [">= 0"])
    s.add_dependency(%q<database_cleaner>, [">= 0"])
    s.add_dependency(%q<capybara>, [">= 0"])
    s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
  end
end
