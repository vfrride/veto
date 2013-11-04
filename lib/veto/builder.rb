require 'veto/conditions'

module Veto			
	class Builder
		attr_reader :context, :context_conditions

		def initialize context, context_conditions={}, &block
			@context = context
			@context_conditions = context_conditions
			instance_eval(&block) if block_given?
		end

		def with_options conditions={}, &block
			context.with_options(merged_conditions(conditions), &block)
		end

		def validates attribute, options={}
			context.validates(attribute, merged_options(options))
		end

		def validate *method_names
			conditions = method_names.last.is_a?(Hash) ? method_names.pop : {}
			method_names.push merged_conditions(conditions)
			context.validate(*method_names)
		end

		private

		def merged_options options
			options.merge(merged_conditions(options))
		end

		def merged_conditions conditions={}
			::Veto::Conditions.merge(context_conditions, conditions)
		end
	end
end