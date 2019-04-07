# TODO: A macro that can define an Enum?
# define_event_types \
#   :input_keypress,
#   :entity_spawn

create_simple_event Empty

create_simple_event Entity,
  entity : Int32

create_simple_event Input,
  key : BLT::TK
