module Veto
	class ValidatorOptions
		def self.parse options
			case options
			when TrueClass
				{}
			when Hash
				options
			when Range, Array
				{ :in => options }
			else
				{ :with => options }
			end
		end
	end
end