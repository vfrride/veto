module Veto
  class WithOptionsBlock < ConditionalBlock
    def self.build(*args)
      new(*args)
    end
  end
end