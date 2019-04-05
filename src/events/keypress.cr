class KeypressEvent < BaseEvent
  property :key
  def initialize(@key : BLT::TK); end
end
