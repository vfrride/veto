require 'veto/checkers/checker'

module Veto
	class InclusionChecker < Checker
		def validate entity, attribute, value, errors, options={}
			set = options.fetch(:in)
			inclusion_method = set.respond_to?(:cover?) ? :cover? : :include?
			message = options.fetch(:message, "is not in set: #{set.inspect}")
			unless set.send(inclusion_method, value)
				errors.add(attribute, message)
			end
		end
	end
end