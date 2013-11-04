require 'veto/validators/attribute_validator'

module Veto
	class InclusionValidator < AttributeValidator
		def validate entity, attribute, value, errors, options={}
			set = options.fetch(:in)
			inclusion_method = set.respond_to?(:cover?) ? :cover? : :include?
			message = options.fetch(:message, "is not in set: #{set.inspect}")
			on = options.fetch(:on, attribute)
			
			unless set.send(inclusion_method, value)
				errors.add(on, message)
			end
		end
	end
end