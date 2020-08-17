#!/usr/bin/env ruby

# frozen_string_literal: true

require 'gosu'

class Vector2D
  def initialize(x, y)
    @x = x
    @y = y
  end

  attr_reader :x, :y

  def self.random
    new(rand(0..400), rand(0..400))
  end
end

class Wall
  def initialize
    @a = Vector2D.random
    @b = Vector2D.random
  end

  attr_reader :a, :b

  def draw
    Gosu.draw_line(@a.x, @a.y,
                   Gosu::Color::WHITE,
                   @b.x, @b.y,
                   Gosu::Color::WHITE)
  end
end

class Camera
  def initialize
    @position = Vector2D.new(200, 200)
  end

  attr_reader :position

  def draw
    Gosu.draw_rect(@position.x - 2, @position.y - 2,
                   4, 4,
                   Gosu::Color::RED,
                   0)
  end
end

class X < Gosu::Window
  def initialize
    super 400, 400
    self.caption = 'FEBE'

    @walls = 8.times.map { Wall.new }
    @camera = Camera.new
  end

  def update
  end

  def draw
    @walls.each(&:draw)
    @camera.draw
  end
end

X.new.show

# ~> ArgumentError
# ~> wrong number of arguments (given 0, expected 1)
# ~>
# ~> /var/folders/6h/wj2by4nn7716wzgzgdbh7twmt3k49g/T/seeing_is_believing_temp_dir20200817-96377-prf07k/program.rb:43:in `draw'
# ~> /var/folders/6h/wj2by4nn7716wzgzgdbh7twmt3k49g/T/seeing_is_believing_temp_dir20200817-96377-prf07k/program.rb:65:in `draw'
# ~> /Users/paul.sonkoly/.rvm/gems/ruby-2.7.1/gems/gosu-0.15.2/lib/gosu/patches.rb:78:in `tick'
# ~> /Users/paul.sonkoly/.rvm/gems/ruby-2.7.1/gems/gosu-0.15.2/lib/gosu/patches.rb:78:in `tick'
# ~> /var/folders/6h/wj2by4nn7716wzgzgdbh7twmt3k49g/T/seeing_is_believing_temp_dir20200817-96377-prf07k/program.rb:69:in `<main>'
