require 'gosu'

class Game < Gosu::Window

  def initialize
    super 800, 600
    self.caption = 'Space Zone'

    @background_image = Gosu::Image.new('media/space.png', :tileable => true)
  end

  def update

  end

  def draw
    @background_image.draw(0, 0, 0)

  end

end

class Player


  def initialize
    @image = Gosu::Image.new('media/starfighter.bmp')
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

  end

  def draw

  end
end

Game.new.show
