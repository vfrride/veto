require 'veto/checkers/checker'

module Veto
	class NumericChecker < Checker
		def validate entity, attribute, value, errors, options={}
			message = options.fetch(:message, "is not a number")
			begin
				Kernel.Float(value.to_s)
				nil
			rescue
				errors.add(attribute, message)
			end
		end
	end
end