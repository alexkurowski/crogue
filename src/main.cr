require "../sys/**"
require "../config/**"
require "./**"

Game = Core.new

unless test?
  Terminal.open
  Game.start
  Game.loop
  Game.finish
  Terminal.close
end
