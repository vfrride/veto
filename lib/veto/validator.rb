require 'veto/errors'
require 'veto/exceptions'
require 'veto/builder'
require 'veto/conditions'
require 'veto/attribute_validator_factory'
require 'veto/validators/custom_method_validator'
require 'veto/validator_options'

module Veto
	module Validator
		def self.included(base)
			base.extend ClassMethods
		end

		module ClassMethods
			def with_options conditions={}, &block
				::Veto::Builder.new(self).with_options(conditions, &block)
			end

			def validates attribute, options={}
				::Veto::Builder.new(self, conditions, &block)
			end

			# def validates attribute, options={}
			# 	::Veto::Conditions.reject(options).each do |type, validator_opts|
			# 		validator_options = ::Veto::ValidatorOptions.parse(validator_opts)
			# 		conditions = ::Veto::Conditions.merge(options, validator_options)
			# 		validate_with ::Veto::AttributeValidatorFactory.new_validator(type, attribute, validator_options.merge(conditions))
			# 	end
			# end		

			# def validate *method_names
			# 	conditions = method_names.last.is_a?(Hash) ? method_names.pop : {}
			# 	[*method_names].each do |method_name|
			# 		validate_with ::Veto::CustomMethodValidator.new(method_name, conditions)
			# 	end
			# end		

			def validate_with validator
				validators.push validator
			end	

			def validators
				@validators ||= []
			end

			def valid? entity
				new(entity).valid?
			end

			def validate! entity
				new(entity).validate!
			end
		end

		def initialize entity
			@entity = entity
		end

		def entity
			@entity
		end

		def errors
			@errors || clear_errors
		end

		def clear_errors
			@errors = ::Veto::Errors.new
		end

		def valid?
			execute
			errors.empty?
		end

		def validate!
			raise(::Veto::InvalidEntity, errors.full_messages) unless valid?
		end

		private

		def execute
			clear_errors
			self.class.validators.each { |validator| validator.execute(self, entity, errors) }
			if entity.respond_to?(:errors=)
				entity.errors = errors
			end
		end
	end
end