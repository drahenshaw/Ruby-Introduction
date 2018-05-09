system "cls"

#Classes

class Square
	attr_reader #creates a getter
	attr_writer	#creates a setter
	attr_accessor :side_length #creates both getter and setter

	def initialize(side_length) #Always start with an initialize method
		@side_length = side_length #instance variable with the @ symbol
	end

	#def side_length #getter - allows us to get the information from the class
		#return @side_length
	#end

	#def side_length=(side_length) #use = side because this is a setter
		#@side_length = side_length
	#end

	def perimeter
		return @side_length * 4
	end

	def area
		return @side_length * @side_length
	end

	def to_s #returns information just by calling my_square
		return "Side_Length: #{@side_length}\nArea: #{area}\nPerimeter: #{perimeter}"
	end

	def draw
		puts "*" * @side_length	
		(@side_length - 2).times do
			print "*" + (' ' * (@side_length - 2)) + "*\n"
			end	
		puts "*" * @side_length	
	end


end


my_square = Square.new(10)


puts my_square.side_length
my_square.side_length = 200
puts my_square.side_length

puts my_square.side_length = 20
puts my_square.draw.to_s
