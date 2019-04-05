abstract class BaseComponent
end

alias Entity = Int32
alias Components = Hash(Symbol, BaseComponent)

class ECS
  getter \
    entities : Array(Entity),
    components : Hash(Entity, Components)

  def initialize
    @entities = [] of Entity
    @components = {} of Entity => Components

    @entity_counter = 0
  end

  def spawn(components : Components) : Int32
    entity = @entity_counter
    @entity_counter += 1

    @components[entity] = components

    Event.trigger :entity_spawn, Event::Entity.new(entity)
    return entity
  end
end
