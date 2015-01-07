class Polygon
	attr_writer :size
	attr_reader :size
end
x = Polygon.new()
x.size =10
puts x.size
