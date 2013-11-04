require 'veto/checkers/checker'

module Veto
	class FormatChecker < Checker
		def validate entity, attribute, value, errors, options={}
			pattern = options.fetch(:with)
			message = options.fetch(:message, "is not valid")
			unless value.to_s =~ pattern
				errors.add(attribute, message)
			end
		end
	end
end