#!/usr/bin/env ruby

# frozen_string_literal: true

require 'gosu'

class X < Gosu::Window
  def initialize
    super 400, 400
    self.caption = 'FEBE'
  end

  def update
  end

  def draw
  end
end

X.new.show
