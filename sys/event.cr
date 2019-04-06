abstract class BaseEvent
end

alias EventCallback = Proc(BaseEvent, Nil)

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
    {% if callback.is_a? NamedTupleLiteral %}
      Event._subscribe {{event}},
        -> (e : BaseEvent) {
          {% for fn, type in callback %}
            if e.is_a? {{type}}
              {{fn.id}} e
            end
          {% end %}
        }
    {% elsif callback.is_a? Call %}
      Event._subscribe {{event}},
        -> (e : BaseEvent) {
          {{callback}}
        }
    {% end %}
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

  def trigger(event : Symbol, data : BaseEvent)
    if @@subscriptions.has_key? event
      @@subscriptions[event].each_value &.call(data)
    end
  end
end
