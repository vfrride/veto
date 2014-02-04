module Veto
	class NumericCheck < AttributeCheck
		def check(attribute, value, errors, options={})
			message = options.fetch(:message, :numeric)
			on = options.fetch(:on, attribute)
			
			begin
				Kernel.Float(value.to_s)
				nil
			rescue
				errors.add(on, message)
			end
		end
	end
end