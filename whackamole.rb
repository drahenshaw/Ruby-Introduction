require 'gosu'

class WhackaMole < Gosu::Window
	def initialize
		super(1280, 720)
		self.caption = "Whack 'a Mole"
		@image = Gosu::Image.new('images/mole.png')
		@hammer = Gosu::Image.new('images/hammer.png')
		@x = 200
		@y = 200
		@width = 100
		@height = 75
		@velocityX = 5
		@velocityY = 5
		@visible = 0 # + visible, - invisible
		@hit = 0
		@font = Gosu::Font.new(30)		
		@score = 0
		@playing = true
		@startTime = 0
	end

	def draw
		if @visible > 0
			@image.draw(@x - @width/2, @y - @height/2, 1)
		end
	
		 #hammer is 50x78		
		@hammer.draw(mouse_x - 25, mouse_y - 39, 1)		

		if @hit == 0
			c = Gosu::Color::NONE
		elsif @hit == 1
			c = Gosu::Color::GREEN
		elsif @hit == -1
			c = Gosu::Color::RED
		end

		draw_quad(0, 0, c, 1280, 0, c, 1280, 720, c, 0, 720, c)
		@hit = 0

		if (@score < 0)
			@font.draw("Score: #{@score.to_s}", 1100, 620, 2, 1, 1, Gosu::Color::RED)
		elsif
			@font.draw("Score: #{@score.to_s}", 1100, 620, 2, 1, 1, Gosu::Color::GREEN)
		end		

		@font.draw("Time: #{@timeLeft}", 10, 10, 2)

		unless @playing
			@font.draw("Game Over!", 300, 300, 3)
			@visible = 20
			@timeLeft = 0
			@font.draw("Press Space to Play Again", 170, 350, 3)
		end
	end

	def update
		if @playing
			@x += @velocityX
			@y += @velocityY
			@velocityX *= -1 if @x + @width/2 > 1280 || @x - @width/2 < 0
			@velocityY *= -1 if @y + @height/2 > 720 || @y - @height/2 < 0
			@visible -= 1 #subtract 1 each frame
			@visible = 30 if @visible < -10 && rand < 0.01 # < frame count & random element
			@timeLeft = (10 - ((Gosu.milliseconds - @startTime)/1000))
			@playing = false if @timeLeft < 0
		end
	end

	def button_down(id)
		if @playing
			if (id == Gosu::MsLeft)								
				if Gosu.distance(mouse_x, mouse_y, @x, @y) < 60 && @visible >= 0 #hammer contacts
					@hit = 1
					@score += 10
				else
					@hit = -1
					@score -= 3
				end
			end	
		else
			if (id == Gosu::KbSpace)
				@playing = true
				@visible = -10
				@startTime = Gosu.milliseconds
				@score = 0
			end
		end
	end
end

window = WhackaMole.new
window.show