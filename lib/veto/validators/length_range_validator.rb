require 'veto/validators/attribute_validator'

module Veto
	class LengthRangeValidator < AttributeValidator
		def validate entity, attribute, value, errors, options={}
			range = options.fetch(:in)
			inclusion_method = range.respond_to?(:cover?) ? :cover? : :include?
			message = options.fetch(:message, "is too short or too long")
			on = options.fetch(:on, attribute)
			
			if value.nil? || !range.send(inclusion_method, value.length)
				errors.add(on, message)
			end
		end
	end
end