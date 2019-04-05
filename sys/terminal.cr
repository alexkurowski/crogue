module Terminal
  extend self
  extend BLTHelper

  @@time : Time::Span = Time.monotonic
  @@default_foreground_color : BLT::Color = color_from_argb 255, 255, 255, 255
  @@default_background_color : BLT::Color = color_from_argb 255, 0, 0, 0

  def open
    BLT.open
    BLT.set "
      window:
        size=#{ INIT_WIDTH }x#{ INIT_HEIGHT },
        title='#{ INIT_TITLE }',
        resizeable=true;

      input:
        filter=[keyboard, mouse, properties];

      font:
        #{ image_path TEXT_FONT },
        size=#{ TEXT_WIDTH }x#{ TEXT_HEIGHT },
        codepage=437;
    "

    BLT.refresh
  end

  def width
    BLT.state BLT::State::WIDTH
  end

  def height
    BLT.state BLT::State::HEIGHT
  end

  def char
    BLT.state BLT::State::CHAR
  end

  def wchar
    BLT.state BLT::State::WCHAR
  end

  def mouse_x
    BLT.state BLT::TK::MOUSE_X
  end

  def mouse_y
    BLT.state BLT::TK::MOUSE_Y
  end

  def input : BLT::TK | Nil
    if BLT.has_input?
      BLT.read
    else
      nil
    end
  end

  def frame_start
    @@time = Time.monotonic
  end

  def frame_end
    sleep_time = 16 - ( Time.monotonic - @@time ).milliseconds
    BLT.delay sleep_time if sleep_time > 0
  end

  def clear
    BLT.color @@default_foreground_color
    BLT.bkcolor @@default_background_color
    BLT.clear
  end

  def put(x, y, c : Int32)
    BLT.put x, y, c
  end

  def put(x, y, c : Char)
    BLT.put x, y, c.ord
  end

  def put(x, y, c : Int32, color : BLT::Color)
    BLT.color color
    BLT.put x, y, c
  end

  def put(x, y, c : Char, color : BLT::Color)
    BLT.color color
    BLT.put x, y, c.ord
  end

  def put(x, y, c : Int32, foreground : BLT::Color, background : BLT::Color)
    BLT.color foreground
    BLT.bkcolor background
    BLT.put x, y, c
  end

  def put(x, y, c : Char, foreground : BLT::Color, background : BLT::Color)
    BLT.color foreground
    BLT.bkcolor background
    BLT.put x, y, c.ord
  end

  def fg_color(name : String)
    BLT.color BLT.color_from_name name
  end

  def fg_color(color : BLT::Color)
    BLT.color color
  end

  def bg_color(name : String)
    BLT.bkcolor BLT.color_from_name name
  end

  def bg_color(color : BLT::Color)
    BLT.bkcolor color
  end

  def reset_colors
    reset_fg_color
    reset_bg_color
  end

  def reset_fg_color
    BLT.color @@default_foreground_color
  end

  def reset_bg_color
    BLT.bkcolor @@default_background_color
  end

  def default_fg_color
    @@default_foreground_color
  end

  def default_bg_color
    @@default_background_color
  end

  def get_char(x : Int32, y : Int32)
    BLT.pick x, y, 0
  end

  def get_fg_color(x : Int32, y : Int32)
    BLT.pick_color x, y, 0
  end

  def get_bg_color(x : Int32, y : Int32)
    BLT.pick_bkcolor x, y
  end

  def print_color(color : BLT::Color)
    "[color=##{ color.to_s 16 }]"
  end

  def print_offset(ox : Int32, oy : Int32)
    "[offset=#{ ox },#{ oy }]"
  end

  def print(x, y, string : String, color : BLT::Color)
    BLT.color color
    print x, y, string
  end

  def print(x, y, string : String, foreground : BLT::Color, background : BLT::Color)
    BLT.color foreground
    BLT.bkcolor background
    print x, y, string
  end

  def print_text(x, y, w, h, string : String)
    BLT.print_ext x, y, w, h, BLT::Align::DEFAULT, string, out outw, out outh
  end

  def print_text(x, y, w, h, string : String, align : BLT::Align)
    BLT.print_ext x, y, w, h, align, string, out outw, out outh
  end

  private def assets_path
    File.expand_path "assets"
  end

  private def image_path(filename)
    File.join assets_path, "images", filename
  end
end
