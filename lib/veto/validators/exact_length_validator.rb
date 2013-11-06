require 'veto/validators/attribute_validator'

module Veto
	class ExactLengthValidator < AttributeValidator
		def validate entity, attribute, value, errors, options={}
			exact = options.fetch(:with)
			message = options.fetch(:message, :exact_length)
			on = options.fetch(:on, attribute)
			
			if value.nil? || value.length != exact
				errors.add(on, message, exact)
			end
		end
	end
end