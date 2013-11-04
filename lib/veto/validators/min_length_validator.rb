require 'veto/validators/attribute_validator'

module Veto
	class MinLengthValidator < AttributeValidator
		def validate entity, attribute, value, errors, options={}
			min = options.fetch(:with)
			message = options.fetch(:message, "is shorter than #{min} characters")
			on = options.fetch(:on, attribute)
			
			if value.nil? || value.length < min
				errors.add(on, message)
			end
		end
	end
end