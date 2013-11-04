module Veto
	class Checker
		def initialize attribute, options={}
			@attribute = attribute
			@options = options
		end

		def execute context, entity
			value = entity.public_send(@attribute)
			errors = context.errors
			validate(entity, @attribute, value, errors, @options)
		end

		def validate entity, attribute, value, errors, options={}
			
		end
	end
end