class Model
  getter \
    ecs : ECS,
    world : World

  def initialize
    Event.subscribe :input_keypress, Event::Keypress, keypress

    @ecs = ECS.new
    @world = World.new
  end

  def update
  end

  def keypress(e : Event::Keypress)
    p e.key
    # case e.key
    # when BLT::TK::H
    #   @player_x -= 1
    # when BLT::TK::L
    #   @player_x += 1
    # end
  end
end
