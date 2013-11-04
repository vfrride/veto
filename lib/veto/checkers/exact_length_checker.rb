require 'veto/checkers/checker'

module Veto
	class ExactLengthChecker < Checker
		def validate entity, attribute, value, errors, options={}
			exact = options.fetch(:with)
			message = options.fetch(:message, "is not #{exact} characters")
			if value.nil? || value.length != exact
				errors.add(attribute, message)
			end
		end
	end
end