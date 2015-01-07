class Polygon
	#getter
	def size
		@size
	end


	#setter
	def size=(number)
		@size=number
	end
end
#create a new polygon
X=Polygon.new
#use setter
X.size=10


#use getter and display
puts X.size