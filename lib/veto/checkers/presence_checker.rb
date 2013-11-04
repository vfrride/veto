require 'veto/checkers/checker'

module Veto
	class PresenceChecker < Checker
		def validate entity, attribute, value, errors, options={}
			message = options.fetch(:message, "is not present")

			v = value.is_a?(String) ? value.gsub(/\s+/, '') : value

			if v.nil? || v.respond_to?(:empty?) && v.empty?
				errors.add(attribute, message)
			end	
		end
	end
end