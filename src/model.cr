class Model
  getter \
    ecs : ECS,
    world : World

  def initialize
    Event.subscribe :input_keypress,
      { keypress: Event::Keypress }

    @ecs = ECS.new
    @world = World.new
  end

  def start
    player = @ecs.spawn({
      player: true,
      position: Component::Position.new(0, 0),
      character: Component::Character.new('@'),
    }.to_h)
  end

  def update
  end

  def keypress(e : Event::Keypress)
    player = Game.model.ecs.find_with :player
    return unless player

    position = Game.model.ecs.components[player][:position].as Component::Position

    case e.key
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
