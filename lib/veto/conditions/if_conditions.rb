module Veto
  class IfConditions < Conditions
    def pass?(*args)
      conditions.each {|c| return(false) unless c.pass?(*args) } 
      true
    end
  end
end