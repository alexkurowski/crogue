class Event::Input < BaseEvent
  getter \
    key : BLT::TK

  def initialize(@key)
  end
end
