require 'veto/checkers/checker'

module Veto
	class LengthRangeChecker < Checker
		def validate entity, attribute, value, errors, options={}
			range = options.fetch(:in)
			inclusion_method = range.respond_to?(:cover?) ? :cover? : :include?
			message = options.fetch(:message, "is too short or too long")
			if value.nil? || !range.send(inclusion_method, value.length)
				errors.add(attribute, message)
			end
		end
	end
end