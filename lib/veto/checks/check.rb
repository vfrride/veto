module Veto
  class Check
    def call(cco)
      raise(NotImplementedError)
    end
  end
end