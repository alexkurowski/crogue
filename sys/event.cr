abstract class BaseEvent
end

alias EventCallback = Proc(BaseEvent, Nil)

# Create an event class with given *properties* assignable on initialization
macro create_simple_event(class_name, *properties)
  class Event::{{class_name}} < BaseEvent
    getter {{
      *properties.map do |property|
        property
      end
    }}

    def initialize(
      {{
        *properties.map do |property|
          "@#{property.var}".id
        end
      }}
    )
    end
  end
end

module Event
  extend self

  @@subscription_counters : Hash(Symbol, Int32) =
    Hash(Symbol, Int32).new 0
  @@subscriptions : Hash(Symbol, Hash(Int32, EventCallback)) =
    Hash(Symbol, Hash(Int32, EventCallback)).new

  # Subscribe a *callback* to *event* by generating an appropriate Proc.
  # ```
  # def simple_callback
  #   p "Simple callback is called with no parameters"
  # end
  #
  # def event_callback(event : Event::Example)
  #   p "Event callback receives an event instance of specified type"
  # end
  #
  # Event.subscribe :event_type, simple_callback
  # Event.subscribe :event_type, { event_callback: Event::Example }
  #
  # Event.trigger :event_type, Event::Example.new
  # ```
  macro subscribe(event, callback)
    {% if callback.is_a? Call %}
      Event._subscribe {{event}},
        -> (e : BaseEvent) {
          {{callback}}
        }
    {% elsif callback.is_a? TypeDeclaration %}
      Event._subscribe {{event}},
        -> (e : BaseEvent) {
          if e.is_a? {{callback.type}}
            {{callback.var}} e
          end
        }
    {% elsif callback.is_a? NamedTupleLiteral %}
      Event._subscribe {{event}},
        -> (e : BaseEvent) {
          {% for fn, type in callback %}
            if e.is_a? {{type}}
              {{fn.id}} e
            end
          {% end %}
        }
    {% end %}
  end

  # Same as above, but allows to match event name with method name
  # ```
  # def callback
  #   p "Callback is called"
  # end
  #
  # Event.subscribe callback
  #
  # Event.trigger :callback
  # ```
  macro subscribe(callback)
    {% if callback.is_a? Call %}
      Event._subscribe :{{callback}},
        -> (e : BaseEvent) {
          {{callback}}
        }
    {% elsif callback.is_a? SymbolLiteral %}
      Event._subscribe {{callback}},
        -> (e : BaseEvent) {
          {{callback.id}}
        }
    {% elsif callback.is_a? TypeDeclaration %}
      Event._subscribe :{{callback.var}},
        -> (e : BaseEvent) {
          if e.is_a? {{callback.type}}
            {{callback.var}} e
          end
        }
    {% end %}
  end

  macro test(x)
    {% p x %}
    {% p x.var %}
    {% p x.value %}
    {% p x.type %}
    {% p x.class_name %}
  end

  def _subscribe(event : Symbol, callback : EventCallback) : Int32
    id = @@subscription_counters[event]
    @@subscription_counters[event] = id + 1

    @@subscriptions[event] ||= {} of Int32 => EventCallback
    @@subscriptions[event][id] = callback
    return id
  end

  def unsubscribe(event : Symbol, id : Int32)
    @@subscriptions[event].delete id
  end

  def trigger(event : Symbol, data : BaseEvent = Event::Empty.new)
    if @@subscriptions.has_key? event
      @@subscriptions[event].each_value &.call(data)
    end
  end
end
