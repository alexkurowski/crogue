class System::Keypress < BaseSystem
  def initialize
    Event.subscribe :input_keypress,
      { execute: Event::Input }
  end

  def execute(input : Event::Input)
    player = Game.model.ecs.find_with :player
    return unless player

    position = Game.model.ecs.components[player].get_position

    case input.key
    when BLT::TK::H
      position.x -= 1
    when BLT::TK::L
      position.x += 1
    when BLT::TK::K
      position.y -= 1
    when BLT::TK::J
      position.y += 1

    when BLT::TK::Y
      position.x -= 1
      position.y -= 1
    when BLT::TK::U
      position.x += 1
      position.y -= 1
    when BLT::TK::B
      position.x -= 1
      position.y += 1
    when BLT::TK::N
      position.x += 1
      position.y += 1
    end
  end
end
