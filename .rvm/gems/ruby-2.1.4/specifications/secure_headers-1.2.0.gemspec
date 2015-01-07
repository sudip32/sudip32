# -*- encoding: utf-8 -*-
# stub: secure_headers 1.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "secure_headers"
  s.version = "1.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Neil Matatall"]
  s.date = "2014-06-13"
  s.description = "Add easily configured browser headers to responses."
  s.email = ["neil.matatall@gmail.com"]
  s.homepage = "https://github.com/twitter/secureheaders"
  s.licenses = ["Apache Public License 2.0"]
  s.rubygems_version = "2.4.5"
  s.summary = "Add easily configured browser headers to responses including content security policy, x-frame-options, strict-transport-security and more."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
