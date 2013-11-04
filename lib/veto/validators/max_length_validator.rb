require 'veto/validators/attribute_validator'

module Veto
	class MaxLengthValidator < AttributeValidator
		def validate entity, attribute, value, errors, options={}
			max = options.fetch(:with)
			message = options.fetch(:message, "is longer than #{max} characters")
			on = options.fetch(:on, attribute)
			
			if value.nil? || value.length > max
				errors.add(on, message)
			end
		end
	end
end