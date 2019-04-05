class Input
  def update
    while input = Terminal.input
      case input
      when BLT::TK::CLOSE
        Game.quit!
      else
        Event.trigger :input_keypress,
          Event::Keypress.new(input)
      end
    end
  end
end
