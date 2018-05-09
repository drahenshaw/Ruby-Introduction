require 'gosu' #similar to #include in C


module ZOrder
	BACKGROUND, STARS, PLAYER, UI = *0..3
end

class Tutorial < Gosu::Window #inheriting from Gosu the Window Class
	def initialize
		super 640, 480 #Size of the window :fullscreen => true to make the game fullscreen
		self.caption = "Ruby Space Game" #Title in the Window of the Game
		@background_image = Gosu::Image.new("images/space.png", :tileable => true) #makes background image available

		@player = Player.new
		@player.warp(320, 240)

		@star_animation = Gosu::Image.load_tiles("images/star.png", 25, 25)
		@stars = Array.new

		@font = Gosu::Font.new(20)
	end

	def update #60 Hz
		if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
     	 @player.turn_left
     	end
    
    	if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
     	 @player.turn_right
    	end

    	if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_BUTTON_0
      	 @player.accelerate
    	end

    	@player.move
    	@player.collect_stars(@stars)

    	if rand(100) < 4 and @stars.size < 25
    		@stars.push(Star.new(@star_animation))
    	end

	end

	def draw
		@background_image.draw(0,0,ZOrder::BACKGROUND) #x, y, z locations for the image
		@player.draw
		@stars.each { |star| star.draw }
		@font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW) #offset 10,10
	end

	

	def button_down(id)
		if id == Gosu::KB_ESCAPE
			close
		else
			super
		end				
	end
end

class Player

	attr_reader :score

	def initialize
		@image = Gosu::Image.new("images/starfighter.bmp") #Image for the starfighter player, pink loaded as transparent
		@beep = Gosu::Sample.new("images/beep.wav")
		@x = @y = @velocity_x = @velocity_y = @angle = 0.0 #initializing variables for movement
		@score = 0
	end

	def warp(x,y)
		@x, @y = x, y #pass x,y in as parameters and turn into instance variables
	end

	def turn_left
		@angle -= 4.5
	end

	def turn_right
		@angle += 4.5
	end

	def accelerate
		@velocity_x +=Gosu.offset_x(@angle, 0.5) #works off functions similar to sin/cos for movement
		@velocity_y +=Gosu.offset_y(@angle, 0.5) 
	end

	def move
		@x += @velocity_x
		@y += @velocity_y
		@x %= 640 #move w respect to frame width
		@y %= 480 #move w respect to frame height
		@velocity_x *= 0.95
		@velocity_y *= 0.95
	end

	def draw
		@image.draw_rot(@x, @y, 1, @angle)
	end

	def score
		@score
	end

	def collect_stars(stars)
		stars.reject! do |star|
			if Gosu.distance(@x, @y, star.x, star.y) < 35
				@score += 10
				@beep.play
				true
			else
				false
			end
		end
	end
end

class Star
	attr_reader :x, :y

	def initialize(animation)
		@animation = animation
		@color = Gosu::Color::BLACK.dup
		@color.red = rand(256 - 40) + 40
		@color.green = rand(256 - 40) + 40
		@color.blue = rand (256 - 40) + 40
		@x = rand * 640
		@y = rand * 480
	end

	def draw
		img = @animation[Gosu.milliseconds / 100 % (@animation.size)]
		img.draw(@x - img.width / 2.0, @y - img.height / 2.0, ZOrder::STARS, 1, 1, @color, :add)		
	end
		
	
end







Tutorial.new.show