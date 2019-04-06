abstract class BaseComponent
end

abstract class BaseSystem
end

alias Entity = Int32
alias ComponentType = BaseComponent | Bool

class Components < Hash(Symbol, ComponentType)
  macro register(class_name)
    {% id = class_name.symbolize.underscore.id %}
    class Components
      def get_{{id}}
        self[:{{id}}].as(Component::{{class_name}})
      end
    end
  end
end

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

  def spawn(**prototype) : Int32
    components = Components.new
    prototype.each do |key, value|
      components[key] = value.as(ComponentType)
    end

    entity = @entity_counter
    @entity_counter += 1

    @entities.push entity
    @components[entity] = components

    Event.trigger :entity_spawn, Event::Entity.new(entity)
    return entity
  end

  def find(key : Symbol) : Components | Nil
    entity = @entities.find do |e|
      @components[e].has_key? key
    end
    @components[entity]
  end

  def find_index(key : Symbol) : Int32 | Nil
    @entities.find do |e|
      @components[e].has_key? key
    end
  end

  def find_all(key : Symbol) : Array(Components)
    @entities
      .select do |e|
        @components[e].has_key? key
      end
      .map do |e|
        @components[e]
      end
  end

  def each(*components, &block)
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
