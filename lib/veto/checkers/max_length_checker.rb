require 'veto/checkers/checker'

module Veto
	class MaxLengthChecker < Checker
		def validate entity, attribute, value, errors, options={}
			max = options.fetch(:with)
			message = options.fetch(:message, "is longer than #{max} characters")
			if value.nil? || value.length > max
				errors.add(attribute, message)
			end
		end
	end
end