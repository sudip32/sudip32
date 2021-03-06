# -*- encoding: utf-8 -*-
# stub: transpec 2.3.6 ruby lib

Gem::Specification.new do |s|
  s.name = "transpec"
  s.version = "2.3.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Yuji Nakayama"]
  s.date = "2014-07-18"
  s.description = "Transpec converts your specs to the latest RSpec syntax with static and dynamic code analysis."
  s.email = ["nkymyj@gmail.com"]
  s.executables = ["transpec"]
  s.files = ["bin/transpec"]
  s.homepage = "http://yujinakayama.me/transpec/"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.4.5"
  s.summary = "The RSpec syntax converter"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<parser>, ["< 3.0", ">= 2.2.0.pre.3"])
      s.add_runtime_dependency(%q<astrolabe>, ["< 0.7", ">= 0.6"])
      s.add_runtime_dependency(%q<bundler>, ["~> 1.3"])
      s.add_runtime_dependency(%q<rainbow>, ["< 3.0", ">= 1.99.1"])
      s.add_runtime_dependency(%q<json>, ["~> 1.8"])
      s.add_runtime_dependency(%q<activesupport>, ["< 5.0", ">= 3.0"])
      s.add_development_dependency(%q<rake>, ["~> 10.1"])
      s.add_development_dependency(%q<rspec>, ["~> 2.14.0"])
      s.add_development_dependency(%q<fuubar>, ["~> 1.3"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.7"])
      s.add_development_dependency(%q<rubocop>, ["~> 0.24"])
      s.add_development_dependency(%q<guard-rspec>, ["< 5.0", ">= 4.2.3"])
      s.add_development_dependency(%q<guard-rubocop>, ["~> 1.0"])
      s.add_development_dependency(%q<guard-shell>, ["~> 0.5"])
      s.add_development_dependency(%q<ruby_gntp>, ["~> 0.3"])
    else
      s.add_dependency(%q<parser>, ["< 3.0", ">= 2.2.0.pre.3"])
      s.add_dependency(%q<astrolabe>, ["< 0.7", ">= 0.6"])
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rainbow>, ["< 3.0", ">= 1.99.1"])
      s.add_dependency(%q<json>, ["~> 1.8"])
      s.add_dependency(%q<activesupport>, ["< 5.0", ">= 3.0"])
      s.add_dependency(%q<rake>, ["~> 10.1"])
      s.add_dependency(%q<rspec>, ["~> 2.14.0"])
      s.add_dependency(%q<fuubar>, ["~> 1.3"])
      s.add_dependency(%q<simplecov>, ["~> 0.7"])
      s.add_dependency(%q<rubocop>, ["~> 0.24"])
      s.add_dependency(%q<guard-rspec>, ["< 5.0", ">= 4.2.3"])
      s.add_dependency(%q<guard-rubocop>, ["~> 1.0"])
      s.add_dependency(%q<guard-shell>, ["~> 0.5"])
      s.add_dependency(%q<ruby_gntp>, ["~> 0.3"])
    end
  else
    s.add_dependency(%q<parser>, ["< 3.0", ">= 2.2.0.pre.3"])
    s.add_dependency(%q<astrolabe>, ["< 0.7", ">= 0.6"])
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rainbow>, ["< 3.0", ">= 1.99.1"])
    s.add_dependency(%q<json>, ["~> 1.8"])
    s.add_dependency(%q<activesupport>, ["< 5.0", ">= 3.0"])
    s.add_dependency(%q<rake>, ["~> 10.1"])
    s.add_dependency(%q<rspec>, ["~> 2.14.0"])
    s.add_dependency(%q<fuubar>, ["~> 1.3"])
    s.add_dependency(%q<simplecov>, ["~> 0.7"])
    s.add_dependency(%q<rubocop>, ["~> 0.24"])
    s.add_dependency(%q<guard-rspec>, ["< 5.0", ">= 4.2.3"])
    s.add_dependency(%q<guard-rubocop>, ["~> 1.0"])
    s.add_dependency(%q<guard-shell>, ["~> 0.5"])
    s.add_dependency(%q<ruby_gntp>, ["~> 0.3"])
  end
end
