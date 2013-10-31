require 'veto/conditions/condition'

module Veto
	class UnlessConditions
		def self.truthy? context, entity, conditions
			[*conditions].each do |condition|
				return true if ::Veto::Condition.truthy?(context, entity, condition)
			end
			false
		end

		def self.falsey? context, entity, conditions
			!truthy?(context, entity, conditions)
		end
	end
end