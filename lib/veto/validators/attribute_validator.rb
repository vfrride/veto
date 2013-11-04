require 'veto/validators/abstract_validator'

module Veto
	class AttributeValidator < AbstractValidator
		def initialize attribute, options={}
			@attribute = attribute
			@options = options
		end

		def execute context, entity, errors
			if truthy_conditions?(@options, context, entity)
				value = entity.public_send(@attribute)
				validate(entity, @attribute, value, errors, @options)
			end
		end

		def validate entity, attribute, value, errors, options={}
			raise NotImplementedError
		end
	end
end

