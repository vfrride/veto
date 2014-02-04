module Veto
  class PrimativeCondition < Condition
    def initialize(object)
      @object = object
    end

    def pass?(*args)
      !!@object
    end
  end
end