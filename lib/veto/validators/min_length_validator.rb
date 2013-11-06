require 'veto/validators/attribute_validator'

module Veto
	class MinLengthValidator < AttributeValidator
		def validate entity, attribute, value, errors, options={}
			min = options.fetch(:with)
			message = options.fetch(:message, :min_length)
			on = options.fetch(:on, attribute)
			
			if value.nil? || value.length < min
				errors.add(on, message, min)
			end
		end
	end
end