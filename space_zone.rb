require 'gosu'

#do z order constant stuff
module ZOrder
  BACKGROUND, STARS, PLAYER, UI = *0..3
end


class Game < Gosu::Window

  def initialize
    super 800, 600
    self.caption = 'Space Zone'

    @background_image = Gosu::Image.new('media/space.png', :tileable => true)

    @player = Player.new
    @player.warp(400, 300)

    @star_anim = Gosu::Image.load_tiles('media/star.png', 25, 25)
    @stars = Array.new

    @font = Gosu::Font.new(20)
    @crazyfrog = Gosu::Song.new('media/crazyfrog.wav')
    @crazyfrog.play(true)
  end

  def update
      #keyboard and gamepad??
    if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
      @player.turn_left
    elsif Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
      @player.turn_right
    elsif Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_UP
      @player.accelerate
    else
    end

    @player.move
    @player.collect_stars(@stars)

    if rand(100) < 4 and @stars.size < 25
      @stars.push(Star.new(@star_anim ))
    end
  end

  def draw
    @player.draw
    @background_image.draw(0, 0, ZOrder::BACKGROUND)
    @stars.each { |star| star.draw}
    @font.draw_text("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
  end

  #exit the game
  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close
    else
      super
    end
  end


end




#main player class
class Player
  attr_reader :score
  def initialize
    @image = Gosu::Image.new('media/starfighter.bmp')
    @beep = Gosu::Sample.new('media/beep.mp3')
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def turn_left
    @angle -= 4.5
  end


  def turn_right
    @angle += 4.5
  end

  def accelerate
    @vel_x += Gosu.offset_x(@angle, 0.5)
    @vel_y += Gosu.offset_y(@angle, 0.5)
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 800
    @y %= 600

    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def draw
    @image.draw_rot(@x, @y, 1 ,@angle)
  end

  def score
    @score
  end

  def collect_stars(stars)
    stars.reject! do |star|
      if Gosu.distance(@x, @y, star.x, star.y) <35
        @score += 10
        @beep.play
        true
      else
        false
      end
    end
  end
end




# Add Star Animations

class Star
  attr_reader :x, :y

  def initialize(animation)
    @animation = animation
    @color = Gosu::Color::BLACK.dup
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
    @x = rand * 640
    @y = rand * 480
  end

  def draw
    img = @animation[Gosu.milliseconds / 100 % @animation.size]
    img.draw(@x - img.width / 2.0, @y - img.height / 2.0,
        ZOrder::STARS, 1, 1, @color, :add)
  end
end




Game.new.show
