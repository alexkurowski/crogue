require "../sys/**"
require "../config/**"
require "./**"

Game = Core.new

if run?
  Terminal.open
  Game.start
  Game.loop
  Game.finish
  Terminal.close
end
