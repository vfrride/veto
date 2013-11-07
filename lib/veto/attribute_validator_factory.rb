require 'veto/validators/exact_length_validator'
require 'veto/validators/format_validator'
require 'veto/validators/greater_than_validator'
require 'veto/validators/greater_than_or_equal_to_validator'
require 'veto/validators/inclusion_validator'
require 'veto/validators/integer_validator'
require 'veto/validators/length_range_validator'
require 'veto/validators/less_than_validator'
require 'veto/validators/less_than_or_equal_to_validator'
require 'veto/validators/max_length_validator'
require 'veto/validators/min_length_validator'
require 'veto/validators/not_null_validator'
require 'veto/validators/numeric_validator'
require 'veto/validators/presence_validator'

module Veto
	class AttributeValidatorFactory
		def self.new_validator type, attribute, options={}
			klass_name = "::Veto::#{camel_case(type.to_s)}Validator"

			begin
			  klass = const_get(klass_name)
			rescue NameError => e
			  raise(ArgumentError, "Validator not found: #{klass_name}")
			end

			klass.new(attribute, options)
		end

		private

		def self.camel_case(str)
			str.split('_').map{|w| w.capitalize }.join('')
		end
	end
end