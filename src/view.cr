class View
  def update
    Terminal.clear
    Terminal.reset_colors

    draw_world
    draw_entities

    Terminal.refresh
  end

  private def draw_world
    world = Game.model.world

    w = Terminal.width
    h = Terminal.height

    # TODO: Camera offset
    x1 = 0
    y1 = 0
    x2 = x1 + w
    y2 = y1 + h

    (x1...x2).each do |x|
      (y1...y2).each do |y|
        Terminal.put x, y, world.char(x, y), world.color(x, y), 0
      end
    end
  end

  private def draw_entities
    Game.model.ecs.each :position, :sprite do |components|
      position = components.get_position
      sprite = components.get_sprite

      Terminal.put position.x, position.y, sprite.char, 0xffffffff, 0
    end
  end
end
