require 'veto/checkers/checker'

module Veto
	class NotNullChecker < Checker
		def validate entity, attribute, value, errors, options={}
			message = options.fetch(:message, "is not present")
			if value.nil?
				errors.add(attribute, message)
			end
		end
	end
end