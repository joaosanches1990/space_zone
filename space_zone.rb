require 'gosu'
require_relative 'player'
require_relative 'star'

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
    elsif Gosu.button_down? Gosu::KB_DOWN
      @player.stop
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
Game.new.show
