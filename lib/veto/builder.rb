require 'veto/conditions'
require 'veto/attribute_validator_factory'
require 'veto/validators/custom_method_validator'

module Veto			
	class Builder
		class ValidatesBuilder
			class ValidatorOptions
				attr_reader :type, :attribute

				def initialize type, attribute, original_options, additional_conditions={}
					@type = type
					@attribute = attribute
					@original_options = original_options
					@additional_conditions = additional_conditions
				end

				def options
					original_options_hash.merge conditions
				end

				def validator
					::Veto::AttributeValidatorFactory.new_validator(type, attribute, options)
				end

				private

				def original_options
					@original_options
				end

				def additional_conditions
					@additional_conditions
				end

				def original_options_hash
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
					::Veto::Conditions.merge(additional_conditions, original_options_hash)
				end
			end

			def self.validators attribute, original_options={}, additional_conditions={}
				new(attribute, original_options, additional_conditions).validators
			end

			attr_reader :attribute, :original_options, :additional_conditions

			def initialize attribute, original_options={}, additional_conditions={}
				@attribute = attribute
				@original_options = original_options
				@additional_conditions = additional_conditions
			end

			def validators
				validator_options.map(&:validator)
			end

			private

			def conditions
				::Veto::Conditions.merge(additional_conditions, ::Veto::Conditions.select(original_options))
			end

			def options
				::Veto::Conditions.reject original_options
			end

			def validator_options
				options.map{|type, opts| new_validator_options(type, opts) }
			end

			def new_validator_options type, opts={}
				ValidatorOptions.new(type, attribute, opts, conditions)
			end
		end

		class ValidateBuilder
			def self.validators method_names_and_conditions, additional_conditions={}
				new(method_names_and_conditions, additional_conditions).validators
			end

			def initialize method_names_and_conditions, additional_conditions={}
				@method_names_and_conditions = method_names_and_conditions
				@additional_conditions = additional_conditions
			end

			def validators
				method_names.map{ |method_name| new_validator(method_name) }
			end

			def method_names
				has_conditions? ? method_names_and_conditions[0..-2] : method_names_and_conditions
			end

			def conditions
				::Veto::Conditions.merge(additional_conditions, original_conditions)
			end

			private

			def new_validator method_name
				::Veto::CustomMethodValidator.new(method_name, conditions)
			end

			def original_conditions
				has_conditions? ? method_names_and_conditions.last : {}
			end

			def has_conditions?
				method_names_and_conditions.last.is_a?(Hash)
			end

			def method_names_and_conditions
				@method_names_and_conditions
			end

			def additional_conditions
				@additional_conditions
			end
		end

		attr_reader :context, :conditions_context

		def initialize context, conditions_context={}, &block
			@context = context
			@conditions_context = conditions_context
			instance_eval(&block) if block_given?
		end

		def with_options conditions={}, &block
			::Veto::Builder.new(context, ::Veto::Conditions.merge(conditions_context, conditions), &block)
		end

		def validates attribute, options={}
			validate_with ValidatesBuilder.validators(attribute, options, conditions_context)
		end

		def validate *method_names
			validate_with ValidateBuilder.validators(method_names, conditions_context)
		end

		def validate_with *args
			context.validate_with *args
		end
	end
end