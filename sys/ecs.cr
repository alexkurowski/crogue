abstract class BaseComponent
end

abstract class BaseSystem
end

alias Entity = Int32
alias Components = Hash(Symbol, BaseComponent | Bool)

class ECS
  getter \
    entities : Array(Entity),
    components : Hash(Entity, Components),
    systems : Array(BaseSystem)

  def initialize
    @entities = [] of Entity
    @components = {} of Entity => Components
    @systems = [] of BaseSystem

    @entity_counter = 0
  end

  def register(system : BaseSystem)
    @systems.push system
  end

  def spawn(components : Components) : Int32
    entity = @entity_counter
    @entity_counter += 1

    @entities.push entity
    @components[entity] = components

    Event.trigger :entity_spawn, Event::Entity.new(entity)
    return entity
  end

  def find_with(key : Symbol) : Int32 | Nil
    @entities.find do |e|
      @components[e].has_key? key
    end
  end

  def find_all_with(key : Symbol) : Array(Int32)
    @entities.select do |e|
      @components[e].has_key? key
    end
  end

  def each_entity(*components, &block)
    @entities.each do |e|
      if has_every_component? e, components
        yield @components[e]
      end
    end
  end

  private def has_every_component?(e : Entity, components : Tuple)
    components.each do |component|
      return false unless @components[e].has_key? component
    end
    true
  end
end
