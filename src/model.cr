class Model
  getter \
    ecs : ECS,
    world : World

  def initialize
    @ecs = ECS.new
    @world = World.new
  end

  def start
    @world.generate

    @ecs.register System::Keypress.new

    @ecs.spawn(
      player: true,
      position: Component::Position.new(0, 0),
      sprite: Component::Sprite.new('@'),
    )
  end

  def update
  end
end
