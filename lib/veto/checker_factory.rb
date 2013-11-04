require 'veto/checkers/exact_length_checker'
require 'veto/checkers/format_checker'
require 'veto/checkers/inclusion_checker'
require 'veto/checkers/integer_checker'
require 'veto/checkers/length_range_checker'
require 'veto/checkers/max_length_checker'
require 'veto/checkers/min_length_checker'
require 'veto/checkers/not_null_checker'
require 'veto/checkers/numeric_checker'
require 'veto/checkers/presence_checker'

module Veto
	class CheckerFactory
		def self.new_checker type, attribute, options={}
			validator_class_name = "::Veto::#{camel_case(type.to_s)}Checker"
			validator_class = const_get(validator_class_name)
			validator_class.new(attribute, options)
		rescue NameError => e
			raise(ArgumentError, "Checker not found: #{validator_class_name}")
		end

		private

		def self.camel_case(str)
			str.split('_').map{|w| w.capitalize }.join('')
		end
	end
end