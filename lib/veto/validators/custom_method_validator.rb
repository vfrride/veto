require 'veto/validators/abstract_validator'

module Veto
	class CustomMethodValidator < AbstractValidator

		attr_reader :method_name, :conditions

		def initialize method_name, conditions
			@method_name = method_name
			@conditions = conditions
		end

		def execute context, entity, errors
			if truthy_conditions?(@conditions, context, entity)
				context.send(method_name)
			end
		end
	end
end