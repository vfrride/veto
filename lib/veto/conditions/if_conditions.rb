require 'veto/conditions/condition'

module Veto
	class IfConditions
		def self.truthy? context, entity, conditions
			return false if conditions.nil?
			[*conditions].each do |condition|
				return false unless ::Veto::Condition.truthy?(context, entity, condition)
			end
			true
		end
	end
end