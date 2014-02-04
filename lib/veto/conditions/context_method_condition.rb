module Veto
  class ContextMethodCondition < Condition
    def initialize(symbol)
      @symbol = symbol
    end

    def pass?(cco)
      !!cco.context.send(@symbol, cco.entity)
    end
  end
end