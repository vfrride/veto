require 'veto/validators/attribute_validator'

module Veto
	class PresenceValidator < AttributeValidator
		def validate entity, attribute, value, errors, options={}
			message = options.fetch(:message, "is not present")
			on = options.fetch(:on, attribute)
			v = value.is_a?(String) ? value.gsub(/\s+/, '') : value

			if v.nil? || v.respond_to?(:empty?) && v.empty?
				errors.add(on, message)
			end	
		end
	end
end