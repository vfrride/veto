module Veto
  class UnlessConditions < Conditions
    def pass?(*args)
      conditions.each {|c| return(false) if c.pass?(*args) } 
      true
    end
  end
end