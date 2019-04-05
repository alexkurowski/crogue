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
    @model.start
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
