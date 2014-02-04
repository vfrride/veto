module Veto
  class Condition
    def pass?(*args)
      raise(NotImplementedError)
    end
  end
end