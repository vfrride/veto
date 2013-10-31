module Veto
	class SymbolCondition 
		def self.match? condition
			condition.is_a?(Symbol)
		end

		def self.truthy? context, entity, condition
			!!context.send(condition)
		end
	end
end