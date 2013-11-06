require 'veto/validators/attribute_validator'

module Veto
	class IntegerValidator < AttributeValidator
		def validate entity, attribute, value, errors, options={}
			message = options.fetch(:message, :integer)
			on = options.fetch(:on, attribute)
			
			begin
				Kernel.Integer(value.to_s)
				nil
			rescue
				errors.add(on, message)
			end
		end
	end
end