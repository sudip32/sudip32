require "rubygems"
require "getsource"
require "source1.rb"
require "source2.rb"

x = X.new
y = Y.new

print "definition of method :foo in #{x}: ", x.method(:foo).body.file,"\n" # source1.rb
print "definition of method :foo in #{y}: ", y.method(:foo).body.file,"\n" # source2.rb

print "definition of method :foo of class X in object #{y}: ", y.specific_method(X,:foo).body.file,"\n" # source1.rb
print "definition of method :foo of class Y in object #{y}: ", y.specific_method(Y,:foo).body.file,"\n" # source1.rb
