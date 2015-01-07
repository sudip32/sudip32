require_relative 'main'
require_relative '../devel/levitate'

if LiveAST.parser::Test.respond_to?(:unified_sexp?) and
    LiveAST.parser::Test.unified_sexp? and
    RUBY_ENGINE != "jruby" then  # jruby takes about a minute
  sections = [
    "Synopsis",
    "+to_ruby+",
    "Noninvasive Interface",
    "Pure Ruby and +ast_eval+",
    "Full Integration",
  ]

  Levitate.doc_to_test("README.rdoc", *sections)
end
