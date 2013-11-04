require 'veto/conditions_evaluator'

module Veto
	class AbstractValidator
		def execute(context, entity, errors)
			raise NotImplementedError
		end

		private

		def truthy_conditions?(conditions, context, entity)
			ConditionsEvaluator.truthy_conditions?(conditions, context, entity)
		end
	end
end