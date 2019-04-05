class View
  def update
    Terminal.clear

    player = Game.model.ecs.find_with :player
    if player
      position = Game.model.ecs.components[player][:position].as Component::Position
      character = Game.model.ecs.components[player][:character].as Component::Character

      Terminal.put position.x, position.y, character.char
    end

    Terminal.refresh
  end
end
