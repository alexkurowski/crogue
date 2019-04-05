class Core
  getter \
    input : Input,
    model : Model,
    view : View

  def initialize
    @input = Input.new
    @model = Model.new
    @view = View.new
  end

  def start
    player = Game.model.ecs.spawn({
      position: Component::Position.new(0, 0),
      character: Component::Character.new('@'),
    }.to_h)
  end

  def loop
    until @done
      @input.update
      @model.update
      @view.update
    end
  end

  def finish
  end

  def quit!
    @done = true
  end
end
