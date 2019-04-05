class Model
  getter \
    ecs : ECS,
    world : World

  def initialize
    Event.subscribe :keypress, keypress

    @ecs = ECS.new
    @world = World.new
  end

  def update
  end

  def keypress(e : KeypressEvent)
    # case e.key
    # when BLT::TK::H
    #   @player_x -= 1
    # when BLT::TK::L
    #   @player_x += 1
    # end
  end
end
