class View
  def update
    Terminal.clear

    draw_entities
    draw_world

    Terminal.refresh
  end

  private def draw_world
    # Game.model.world ...
  end

  private def draw_entities
    Game.model.ecs.each_entity(:position, :sprite) do |components|
      position = components.get_position
      sprite = components.get_sprite

      Terminal.put position.x, position.y, sprite.char
    end
  end
end
