module Veto
	class GreaterThanCheck < AttributeCheck
		def check(attribute, value, errors, options={})
			boundary = options.fetch(:with)		
			message = options.fetch(:message, :greater_than)
			on = options.fetch(:on, attribute)
			
			begin
				v = Kernel.Float(value.to_s)
				nil
			rescue
				return errors.add(on, message, boundary)
			end

			unless v > boundary
				errors.add(on, message, boundary)
			end
		end
	end
end