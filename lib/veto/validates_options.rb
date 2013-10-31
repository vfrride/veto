module Veto
	class ValidatesOptions
		class ValidatorOptions
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
				options.select{ |k,v| CONDITIONAL_KEYS.include?(k) }
			end

			private

			def original_options
				@options
			end
		end

		CONDITIONAL_KEYS = [:if, :unless].freeze

		attr_reader :attribute, :options

		def initialize attribute, options={}
			@attribute = attribute
			@options = options
		end

		def conditions
			options.select{ |k,v| CONDITIONAL_KEYS.include?(k) }
		end

		def each_validator_options &block
			validator_options.each &block
		end

		private

		def validator_options
			validator_options_hash.map{|type, opts| new_validator_options(type, opts) }
		end

		def validator_options_hash
			options.reject{ |k,v| CONDITIONAL_KEYS.include?(k) }
		end

		def new_validator_options type, opts
			ValidatorOptions.new(type, attribute, opts)
		end
	end
end