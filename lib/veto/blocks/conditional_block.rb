module Veto
  class ConditionalBlock < Block
    def initialize(options={})
      @options = options
      super()
    end

    def call(*args)
      call_children(*args) if conditions.pass?(*args)
    end

    def options(hash={})
      conditions_filter(:reject)
    end

    private

    def conditions
      IfUnlessConditions.new(conditions_filter(:select))
    end

    def conditions_filter(type)
      @options.send(type){|k,v| [:if, :unless].include?(k)}
    end
  end
end