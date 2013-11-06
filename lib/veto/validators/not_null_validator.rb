require 'veto/validators/attribute_validator'

module Veto
	class NotNullValidator < AttributeValidator
		def validate entity, attribute, value, errors, options={}
			message = options.fetch(:message, :not_null)
			on = options.fetch(:on, attribute)
			
			if value.nil?
				errors.add(on, message)
			end
		end
	end
end