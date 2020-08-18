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

  def distance_from(other)
    Math.sqrt((x - other.x) ** 2 + (y - other.y) ** 2)
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

    @rays = (-Math::PI / 4).step(to: Math::PI / 4, by: Math::PI / 36).map.with_index do |direction, index|
      Ray.new(self, direction, index)
    end
  end

  attr_reader :position, :direction

  def draw(walls)
    Gosu.draw_rect(@position.x - 2, @position.y - 2,
                   4, 4,
                   Gosu::Color::RED,
                   0)

    @rays.each { |ray| ray.draw(walls) }
  end

  def move(scalar)
    @position = @position + @direction.to_vector2D * scalar
  end

  def turn(rad)
    @direction = @direction.rotate(rad)
  end
end

class Ray
  def initialize(camera, direction, index)
    @camera = camera
    @direction = direction
    @index = index
  end

  def position
    @camera.position
  end

  def direction
    @camera.direction.rotate(@direction)
  end

  def draw(walls)
    hits = walls.map { |wall| cast(wall) }.compact
    closest = hits.min_by { |hit| position.distance_from(hit) }

    if closest
      Gosu.draw_line(position.x, position.y, Gosu::Color::WHITE,
                     closest.x, closest.y, Gosu::Color::WHITE, 0)

      distance = position.distance_from(closest)
      distance *= Math.cos(@direction)

      width = 400.fdiv 18
      height = linear_map distance, 0, 400, 400, 50

      y_offset = (400 - height) / 2
      shade = linear_map(distance, 0, 400, 255, 0)
      Gosu.draw_rect(400 + @index * width,
                     y_offset,
                     width,
                     height,
                     Gosu::Color.rgba(shade, shade, shade, 255))
    end
  end

  private

  def linear_map(value, mina, maxa, minb, maxb)
    (maxb - minb) * (value - mina) / (maxa - mina) + minb
  end

  def point_behind
    position - direction.to_vector2D
  end

  def cast(wall)
    x1=position.x
    y1=position.y
    x2=point_behind.x
    y2=point_behind.y
    x3=wall.a.x
    y3=wall.a.y
    x4=wall.b.x
    y4=wall.b.y

    denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
    t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denom
    u = ((y1 - y2) * (x1 - x3) - (x1 - x2) * (y1 - y3)) / denom

    if 0 <= u && t <= 0 && u <= 1.0 then
      Vector2D.new(x1 + t * (x2 - x1), y1 + t * (y2 - y1))
    end
  end
end

class X < Gosu::Window
  def initialize
    super 800, 400
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

      when Gosu::KB_A
        @camera.turn(-Math::PI / 36)

      when Gosu::KB_D
        @camera.turn(Math::PI / 36)
      end

    end
  end

  def draw
    @walls.each(&:draw)
    @camera.draw(@walls)
  end

  def button_down(id)
    if [Gosu::KB_A, Gosu::KB_S, Gosu::KB_D, Gosu::KB_W].include? id
      @pressed = @pressed | [id]
    end
  end

  def button_up(id)
    @pressed = @pressed - [id]
  end
end

X.new.show

# ~> TypeError
# ~> Direction can't be coerced into Float
# ~>
# ~> /var/folders/6h/wj2by4nn7716wzgzgdbh7twmt3k49g/T/seeing_is_believing_temp_dir20200818-76816-9xntsl/program.rb:134:in `-'
# ~> /var/folders/6h/wj2by4nn7716wzgzgdbh7twmt3k49g/T/seeing_is_believing_temp_dir20200818-76816-9xntsl/program.rb:134:in `draw'
# ~> /var/folders/6h/wj2by4nn7716wzgzgdbh7twmt3k49g/T/seeing_is_believing_temp_dir20200818-76816-9xntsl/program.rb:98:in `block in draw'
# ~> /var/folders/6h/wj2by4nn7716wzgzgdbh7twmt3k49g/T/seeing_is_believing_temp_dir20200818-76816-9xntsl/program.rb:98:in `each'
# ~> /var/folders/6h/wj2by4nn7716wzgzgdbh7twmt3k49g/T/seeing_is_believing_temp_dir20200818-76816-9xntsl/program.rb:98:in `draw'
# ~> /var/folders/6h/wj2by4nn7716wzgzgdbh7twmt3k49g/T/seeing_is_believing_temp_dir20200818-76816-9xntsl/program.rb:210:in `draw'
# ~> /Users/paul.sonkoly/.rvm/gems/ruby-2.7.1/gems/gosu-0.15.2/lib/gosu/patches.rb:78:in `tick'
# ~> /Users/paul.sonkoly/.rvm/gems/ruby-2.7.1/gems/gosu-0.15.2/lib/gosu/patches.rb:78:in `tick'
# ~> /var/folders/6h/wj2by4nn7716wzgzgdbh7twmt3k49g/T/seeing_is_believing_temp_dir20200818-76816-9xntsl/program.rb:224:in `<main>'
