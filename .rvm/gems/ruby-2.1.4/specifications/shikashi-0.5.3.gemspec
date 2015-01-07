# -*- encoding: utf-8 -*-
# stub: shikashi 0.5.3 ruby lib

Gem::Specification.new do |s|
  s.name = "shikashi"
  s.version = "0.5.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Dario Seminara"]
  s.date = "2013-09-14"
  s.email = "robertodarioseminara@gmail.com"
  s.extra_rdoc_files = ["README"]
  s.files = ["README"]
  s.homepage = "http://github.com/tario/shikashi"
  s.rubygems_version = "2.4.5"
  s.summary = "shikashi is a ruby sandbox that permits the execution of \"unprivileged\" scripts by defining the permitted methods and constants the scripts can invoke with a white list logic"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<evalhook>, [">= 0.5.5"])
      s.add_runtime_dependency(%q<getsource>, [">= 0.1.0"])
    else
      s.add_dependency(%q<evalhook>, [">= 0.5.5"])
      s.add_dependency(%q<getsource>, [">= 0.1.0"])
    end
  else
    s.add_dependency(%q<evalhook>, [">= 0.5.5"])
    s.add_dependency(%q<getsource>, [">= 0.1.0"])
  end
end
