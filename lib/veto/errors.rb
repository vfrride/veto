module Veto
  class Errors < ::Hash
    def add(atr, msg, *msg_opts)
      fetch(atr){self[atr] = []} << msg_lookup(msg, *msg_opts)
    end

    def count
      values.inject(0){|m, v| m + v.length}
    end

    def empty?
      count == 0
    end

    def full_messages
      inject([]) do |m, kv| 
        atr, errors = *kv
        errors.each {|e| m << "#{atr} #{e}"}
        m
      end
    end

    def on(atr)
      if v = fetch(atr, nil) and !v.empty?
        v
      end
    end

    private

    def msg_lookup(msg, *msg_opts)
      msg.is_a?(Symbol) ? ::Veto.configuration.message.get(msg, *msg_opts) : msg
    end
  end
end