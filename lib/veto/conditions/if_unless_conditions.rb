module Veto
  class IfUnlessConditions < Condition
    def initialize(options)
      @options = options
    end

    def pass?(*args)
      if_conditions.pass?(*args) && unless_conditions.pass?(*args)
    end

    private

    def if_conditions
      IfConditions.new(@options[:if])
    end

    def unless_conditions
      UnlessConditions.new(@options[:unless])
    end
  end
end