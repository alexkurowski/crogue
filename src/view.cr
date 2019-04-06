class View
  def update
    Terminal.clear

    draw_entities

    Terminal.refresh
  end

  private def draw_entities
    Game.model.ecs.each_entity do |components|
      should_draw =
        components.has_key?(:position) &&
        components.has_key?(:sprite)

      return unless should_draw

      position = components[:position].as Component::Position
      sprite = components[:sprite].as Component::Sprite

      Terminal.put position.x, position.y, sprite.char
    end
  end
end
