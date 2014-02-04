module Veto
  class ProcCondition < Condition
    def initialize(proc)
      @proc = proc
    end

    def pass?(cco)
      !!@proc.call(cco.entity)
    end
  end
end