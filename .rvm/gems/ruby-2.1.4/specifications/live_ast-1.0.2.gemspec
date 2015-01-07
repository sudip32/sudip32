# -*- encoding: utf-8 -*-
# stub: live_ast 1.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "live_ast"
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["James M. Lawrence"]
  s.date = "2011-08-02"
  s.description = "LiveAST enables a program to find the ASTs of objects created by dynamically generated code."
  s.email = ["quixoticsycophant@gmail.com"]
  s.extra_rdoc_files = ["README.rdoc", "CHANGES.rdoc"]
  s.files = ["CHANGES.rdoc", "README.rdoc"]
  s.homepage = "http://quix.github.com/live_ast"
  s.rdoc_options = ["--main", "README.rdoc", "--title", "LiveAST: Live Abstract Syntax Trees", "--exclude", "lib/live_ast/ast_load.rb", "--exclude", "lib/live_ast/common.rb", "--exclude", "lib/live_ast/error.rb", "--exclude", "lib/live_ast/evaler.rb", "--exclude", "lib/live_ast/full.rb", "--exclude", "lib/live_ast/irb_spy.rb", "--exclude", "lib/live_ast/linker.rb", "--exclude", "lib/live_ast/loader.rb", "--exclude", "lib/live_ast/reader.rb", "--exclude", "lib/live_ast/replace_eval.rb", "--exclude", "lib/live_ast/replace_load.rb", "--exclude", "lib/live_ast/replace_raise.rb", "--exclude", "lib/live_ast.rb", "-a"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubygems_version = "2.4.5"
  s.summary = "Live abstract syntax trees of methods and procs."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<live_ast_ruby_parser>, [">= 0.6.0"])
    else
      s.add_dependency(%q<live_ast_ruby_parser>, [">= 0.6.0"])
    end
  else
    s.add_dependency(%q<live_ast_ruby_parser>, [">= 0.6.0"])
  end
end
