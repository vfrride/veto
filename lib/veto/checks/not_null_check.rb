module Veto
	class NotNullCheck < AttributeCheck
		def check(attribute, value, errors, options={})
			message = options.fetch(:message, :not_null)
			on = options.fetch(:on, attribute)
			
			if value.nil?
				errors.add(on, message)
			end
		end
	end
end