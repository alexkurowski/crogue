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
      position = components[:position].as Component::Position
      sprite = components[:sprite].as Component::Sprite

      Terminal.put position.x, position.y, sprite.char
    end
  end
end
