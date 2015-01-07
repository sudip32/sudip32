c=0
temp = {'a'=>1232, 'b'=>2342}
temp.each do|keys,values|
c += values
end
puts "total number is #{c}"

temp.each {|k,v| c+=v }
sum = 	temp.inject(0) do |sum, (k,v)|
			sum += v
		end
