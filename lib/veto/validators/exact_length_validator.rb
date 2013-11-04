require 'veto/validators/attribute_validator'

module Veto
	class ExactLengthValidator < AttributeValidator
		def validate entity, attribute, value, errors, options={}
			exact = options.fetch(:with)
			message = options.fetch(:message, "is not #{exact} characters")
			on = options.fetch(:on, attribute)
			
			if value.nil? || value.length != exact
				errors.add(on, message)
			end
		end
	end
end