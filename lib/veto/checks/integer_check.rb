module Veto
	class IntegerCheck < AttributeCheck
		def check(attribute, value, errors, options={})
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