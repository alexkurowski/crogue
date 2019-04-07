abstract class BaseComponent
end

abstract class BaseSystem
end

alias Entity = Int32

alias ComponentType = BaseComponent | Bool

class Components < Hash(Symbol, ComponentType)
  # Create a method that returns our component with a correct higher type,
  # so we can do the following:
  # `components.get_position`
  # instead of long and convoluted manual casting:
  # `components[:position].as(Component::Position)`
  macro register(class_name)
    {% id = class_name.symbolize.underscore.id %}
    class Components
      def get_{{id}}
        self[:{{id}}].as(Component::{{class_name}})
      end
    end
  end
end

# Create a component class with given *properties* assignable on initialization.
# Properties do expect default values to be present.
macro create_simple_component(class_name, *properties)
  class Component::{{class_name}} < BaseComponent
    property {{
      *properties.map do |property|
        property
      end
    }}

    def initialize(
      {{
        *properties.map do |property|
          "@#{property.var} = #{property.value}".id
        end
      }}
    )
    end
  end

  Components.register({{class_name}})
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
