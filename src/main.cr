require "../sys/**"
require "../config/**"
require "./**"

Game = Core.new

Terminal.open
Game.start
Game.loop
Game.finish
Terminal.close
