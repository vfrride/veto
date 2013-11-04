require 'veto/checkers/checker'

module Veto
	class MinLengthChecker < Checker
		def validate entity, attribute, value, errors, options={}
			min = options.fetch(:with)
			message = options.fetch(:message, "is shorter than #{min} characters")
			if value.nil? || value.length < min
				errors.add(attribute, message)
			end
		end
	end
end