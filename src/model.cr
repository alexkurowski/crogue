class Model
  getter \
    ecs : ECS,
    world : World

  def initialize
    @ecs = ECS.new
    @world = World.new
  end

  def start
    @ecs.register System::Keypress.new

    @ecs.spawn(
      player: true,
      position: Component::Position.new(0, 0),
      sprite: Component::Sprite.new('@'),
    )

    @ecs.spawn(
      player: true,
      position: Component::Position.new(10, 0).as(BaseComponent),
    )
  end

  def update
  end
end
