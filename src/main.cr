require "../sys/**"
require "./**"

Game = Core.new

Terminal.open
Game.start
Game.loop
Game.finish
Terminal.close
