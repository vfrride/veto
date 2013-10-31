require 'veto/validator_list'
require 'veto/conditions'

module Veto
	class ConditionalValidatorList

		attr_reader :conditions

		def initialize conditions={}
			@conditions = conditions
		end

		def validate context, entity, errors
			if conditions_truthy?(context, entity)
				validator_list.validate(context, entity, errors)
			end
		end

		def add *args
			validator_list.add *args
		end

		private

		def validator_list
			@validator_list ||= ::Veto::ValidatorList.new
		end

		def conditions_truthy? context, entity
			::Veto::Conditions.truthy?(context, entity, conditions)
		end
	end
end