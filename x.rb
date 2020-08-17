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

  def +(other)
    Vector2D.new(x + other.x, y + other.y)
  end

  def -(other)
    self + other * -1
  end

  def *(scalar)
    Vector2D.new(x * scalar, y * scalar)
  end
end

class Direction
  def initialize(direction = 0)
    @direction = direction
  end

  def rotate(rad)
    Direction.new(@direction + rad)
  end

  def to_vector2D
    Vector2D.new(Math.cos(@direction), Math.sin(@direction))
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
    @direction = Direction.new
  end

  attr_reader :position

  def draw
    Gosu.draw_rect(@position.x - 2, @position.y - 2,
                   4, 4,
                   Gosu::Color::RED,
                   0)
  end

  def move(scalar)
    @position = @position + @direction.to_vector2D * scalar
  end
end

class X < Gosu::Window
  def initialize
    super 400, 400
    self.caption = 'FEBE'

    @walls = 8.times.map { Wall.new }
    @camera = Camera.new
    @pressed = []
  end

  def update
    @pressed.each do |key|
      case key
      when Gosu::KB_W
        @camera.move(1.0)

      when Gosu::KB_S
        @camera.move(-1.0)
      end

    end
  end

  def draw
    @walls.each(&:draw)
    @camera.draw
  end

  def button_down(id)
    if [Gosu::KB_S, Gosu::KB_W].include? id
      @pressed = @pressed | [id]
    end
  end

  def button_up(id)
    @pressed = @pressed - [id]
  end
end

X.new.show
