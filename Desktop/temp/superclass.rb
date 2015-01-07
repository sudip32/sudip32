class Living_things
	@@no_of_object=0;

	def initialize (name)
		@name=name
		@@no_of_object += 1

	end
	def display
		puts "Number of objects #{@@no_of_object}"
	end


	

end
class Animal < Living_things
	def initialize(name)
		super(name)
	end
end
s1=Animal.new("dog")
s1.display
s2=Animal.new("cat")
s2.display
s1.display




	



