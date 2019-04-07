abstract class BaseTile
end

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

TILE_TYPES = {} of Symbol => BaseTile

class World
  # TODO: Use Slice for tile map

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
      end
    end
  end

  def char(x : Int32, y : Int32) : Char | Int32
    TILE_TYPES[@tiles[x][y]].char
  end

  def color(x : Int32, y : Int32) : BLT::Color
    TILE_TYPES[@tiles[x][y]].color
  end

  private def random_tile(sym : Symbol) : Symbol
    str = sym.to_s
    TILE_TYPES.keys
      .select { |type| type.to_s.starts_with? str }
      .sample
  end
end
