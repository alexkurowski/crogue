class Input
  def update
    while input = Terminal.input
      case input
      when BLT::TK::CLOSE
        Game.quit!
      else
        Event.trigger :keypress, KeypressEvent.new(input)
      end
    end
  end
end
