class Year
	def initialize(current,old)
		@current=current
		@old=old


	end
	def age
		calculate

	

	end


		private 


		def calculate

			a=@current-@old
			puts"age is #{a}"
		end
end


		s1=Year.new(2014,2012)
		puts s1.age

