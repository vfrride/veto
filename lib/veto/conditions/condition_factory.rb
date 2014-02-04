module Veto
  class ConditionFactory
    def self.new(condition_option)
      condition_class = 
        case condition_option
        when String
          EntityEvalCondition
        when Symbol
          ContextMethodCondition
        when Proc
          ProcCondition
        else
          PrimativeCondition
        end
      condition_class.new(condition_option)
    end
  end
end