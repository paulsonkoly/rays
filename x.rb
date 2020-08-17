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

class X < Gosu::Window
  def initialize
    super 400, 400
    self.caption = 'FEBE'

    @walls = 8.times.map { Wall.new }
  end

  def update
  end

  def draw
    @walls.each(&:draw)
  end
end

X.new.show
