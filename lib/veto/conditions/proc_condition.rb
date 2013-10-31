module Veto
	class ProcCondition
		def self.match? condition
			condition.is_a?(Proc)
		end

		def self.truthy? context, entity, condition
			!!condition.call(entity)
		end
	end
end