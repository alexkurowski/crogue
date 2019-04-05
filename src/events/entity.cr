class Event::Entity < BaseEvent
  getter \
    entity : Int32

  def initialize(@entity)
  end
end
