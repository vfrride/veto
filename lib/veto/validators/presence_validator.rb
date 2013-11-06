require 'veto/validators/attribute_validator'

module Veto
	class PresenceValidator < AttributeValidator
		def validate entity, attribute, value, errors, options={}
			msg = options.fetch(:message, :presence)
			on = options.fetch(:on, attribute)
			v = value.is_a?(String) ? value.gsub(/\s+/, '') : value

			if v.nil? || v.respond_to?(:empty?) && v.empty?
				errors.add(on, msg)
			end	
		end
	end
end