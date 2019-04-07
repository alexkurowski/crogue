create_tile :none,
  color : BLT::Color = 0,
  char : Char = ' '

create_tiles :water,
  [ '~', '≈', '=' ],
  [
    Terminal.rgba(40,  80, 200),
    Terminal.rgba(80, 120, 220),
    Terminal.rgba(10, 110, 200),
    Terminal.rgba(30, 120, 180)
  ]

create_tiles :grass,
  [ '"', '\'', '`' ],
  [
    Terminal.rgba(120, 180, 10),
    Terminal.rgba(10, 140, 10),
    Terminal.rgba(90, 140, 70)
  ]
