class Component::Position < BaseComponent
  property \
    x : Int32,
    y : Int32

  def initialize(@x = 0, @y = 0)
  end
end

Components.register Position
