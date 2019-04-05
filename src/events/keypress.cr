class Event::Keypress < BaseEvent
  getter \
    key : BLT::TK

  def initialize(@key)
  end
end
