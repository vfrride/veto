module Veto
	class StringCondition
		def self.match? condition
			condition.is_a?(String)
		end

		def self.truthy? context, entity, condition
			!!entity.instance_eval(condition)
		end
	end
end