require 'veto/validators/exact_length_validator'
require 'veto/validators/format_validator'
require 'veto/validators/inclusion_validator'
require 'veto/validators/integer_validator'
require 'veto/validators/length_range_validator'
require 'veto/validators/max_length_validator'
require 'veto/validators/min_length_validator'
require 'veto/validators/not_null_validator'
require 'veto/validators/numeric_validator'
require 'veto/validators/presence_validator'
require 'veto/validators/type_validator'

module Veto
	class ValidatorFactory
		def self.new_validator type, attribute, options={}
			validator_class_name = "::Veto::#{camel_case(type.to_s)}Validator"
			validator_class = const_get(validator_class_name)
			validator_class.new(attribute, options)
		rescue NameError => e
			raise(ArgumentError, "Validator not found: #{validator_class_name}")
		end

		private

		def self.camel_case(str)
			str.split('_').map{|w| w.capitalize }.join('')
		end
	end
end