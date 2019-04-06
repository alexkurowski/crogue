class Component::Sprite < BaseComponent
  property \
    char : Char

  def initialize(@char)
  end
end

Components.register Sprite
