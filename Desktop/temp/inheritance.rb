class Animal
	attr_accessor :name

	def initialize(name)#constructor
		@name=name
	end

	def eat(other)
		puts"#{@name} ate#{other.name}! #{self.noise}"
	end
		
	end


	class Human < Animal
		def initialize(name,catchphrase)
			super(name)
			@catchphrase=catchphrase
			
		end
		def noise
			@catchphrase
			
		end
	end
	human=Human.new("sabi gaire","chitwan!")

	 puts human.noise
	 animal=Animal.new ("chicken")
	 human.eat(animal)

