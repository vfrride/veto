module Veto
	class ValidatorConfig
		attr_reader :type, :attribute

		def initialize type, attribute, options
			@type = type
			@attribute = attribute
			@options = options
		end

		def options
			case original_options
			when TrueClass
				{}
			when Hash
				original_options
			when Range, Array
				{ :in => original_options }
			else
				{ :with => original_options }
			end
		end

		def conditions
			original_options.is_a?(Hash) ? original_options : {}
		end

		private

		def original_options
			@options
		end
	end
end