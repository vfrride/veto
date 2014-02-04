module Veto
  class PassingCondition < Condition
    def pass?(*args)
      true
    end
  end
end