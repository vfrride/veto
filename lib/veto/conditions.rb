require 'veto/conditions/if_conditions'
require 'veto/conditions/unless_conditions'

module Veto
	class Conditions
		def self.truthy? context, entity, conditions
			IfConditions.truthy?(context, entity, conditions[:if]) &&
				UnlessConditions.falsey?(context, entity, conditions[:unless])
		end
	end
end
