module Veto
	class FormatCheck < AttributeCheck

		private

		def check(attribute, value, errors, options={})
			pattern = options.fetch(:with)
			message = options.fetch(:message, :format)
			on = options.fetch(:on, attribute)
			
			unless value.to_s =~ pattern
				errors.add(on, message)
			end
		end
	end
end