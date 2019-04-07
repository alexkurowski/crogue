abstract class BaseTile
end

TILE_TYPES = {} of Symbol => BaseTile

# Create a tile class with given properties, and register it in a global
# TILE_TYPES hash map
macro create_tile(class_name, *properties)
  class Tile::{{class_name.capitalize.id}} < BaseTile
    property {{
      *properties.map do |property|
        property
      end
    }}
  end

  TILE_TYPES[{{class_name}}] = Tile::{{class_name.capitalize.id}}.new
end

# Create a multiple tile classes each with a set of given properties,
# register each class in a global TILE_TYPES hash map
macro create_tiles(class_prefix, chars, colors)
  {% i = 0 %}
  {% for color in colors %}
    {% for char in chars %}
      class Tile::{{class_prefix.capitalize.id}}{{i}} < BaseTile
        property \
          char : Char = {{char}},
          color : BLT::Color = {{color}}
      end

      TILE_TYPES[{{class_prefix}}_{{i}}] = Tile::{{class_prefix.capitalize.id}}{{i}}.new
      {% i = i + 1 %}
    {% end %}
  {% end %}
end

class World
  getter \
    tiles : Array(Array(Symbol))

  def initialize
    @tiles = Array(Array(Symbol)).new
  end

  def generate
    WIDTH.times do |x|
      @tiles << [] of Symbol
      HEIGHT.times do |y|
        @tiles[x] << :none
      end
    end

    (8..12).each do |y|
      100.times do |x|
        @tiles[x][y] = random_tile :grass
        @tiles[x][y + 4] = random_tile :water
      end
    end
  end

  def get(x : Int32, y : Int32) : Symbol
    return :none if x < 0 || x > WIDTH - 1 ||
                    y < 0 || y > HEIGHT - 1
    @tiles[x][y]
  end

  def char(x : Int32, y : Int32) : Char | Int32
    TILE_TYPES[get x, y].char
  end

  def color(x : Int32, y : Int32) : BLT::Color
    TILE_TYPES[get x, y].color
  end

  private def random_tile(sym : Symbol) : Symbol
    str = sym.to_s
    TILE_TYPES.keys
      .select { |type| type.to_s.starts_with? str }
      .sample
  end
end
