module Veto
	class ContextMethodValidator
		attr_reader :method_name

		def initialize method_name
			@method_name = method_name
		end

		def execute context, entity
			context.send(method_name)
		end
	end
end