abstract class BaseEvent; end

alias EventCallback = Proc(BaseEvent, Nil)

module Event
  extend self

  @@subscription_counters : Hash(Symbol, Int32) =
    Hash(Symbol, Int32).new 0
  @@subscriptions : Hash(Symbol, Hash(Int32, EventCallback)) =
    Hash(Symbol, Hash(Int32, EventCallback)).new

  macro subscribe(event, fn)
    Event._subscribe {{event}},
      -> (e : BaseEvent) {
        {{fn}} e
      }
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
    @@subscriptions[event].each_value &.call(data)
  end
end
