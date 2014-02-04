module Veto
  class EntityEvalCondition < Condition
    def initialize(eval_string)
      @eval_string = eval_string
    end

    def pass?(cco)
      !!cco.entity.instance_eval(@eval_string)
    end
  end
end