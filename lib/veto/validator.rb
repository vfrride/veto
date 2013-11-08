require 'veto/errors'
require 'veto/exceptions'
require 'veto/builder'

module Veto
	module Validator
		def self.included(base)
			base.extend ClassMethods
		end

		module ClassMethods
			def with_options *args, &block
				builder.with_options(*args, &block)
			end

			def validates *args
				builder.validates(*args)
			end

			def validate *args
				builder.validate(*args)
			end

			# Used to add a validator, or set of validators, to the 
			# validators list. Generally used by the `validates` and `validate`
			# methods internally.
			#
			# @example 
			#   PersonValidator.validates_with PresenceValidator.new(:first_name)
			#     # OR
			#   PersonValidator.validates_with PresenceValidator.new(:first_name), IntegerValidator.new(:age)
			#
			# @param validator_set [Array] A single, or list, of validator instances
			def validate_with *validator_set
				validators.concat validator_set.flatten
			end	

			# Memoizes a flat list of internal validator instances that 
			# will perform validations on the assigned entity.
			#
			# @example
			#   PersonValidator.validators # => [
			#       <Veto::FormatValidator:0xXXXXXX @attribute=#<Mock:0xXXXXXX>, @options=#<Mock:0xXXXXXX>>,
			#       <Veto::PresenceValidator:0xXXXXXX @attribute=#<Mock:0xXXXXXX>, @options=#<Mock:0xXXXXXX>>,
			#       <Veto::ExactLengthValidator:0xXXXXXX @attribute=#<Mock:0xXXXXXX>, @options=#<Mock:0xXXXXXX>>]
			#
			# @return [Array]
			def validators
				@validators ||= []
			end
			
			# Returns boolean value representing the validaty of the entity
			#
			# @param entity [Object] the entity instance to validate.
        	#
        	# @return [Boolean]
			def valid? *args
				new(*args).valid?
			end

			# Raises exception if entity is invalid
			#
			# @example
			#   person = Person.new
			#   PersonValidator.validate!(person) # => Veto::InvalidEntity, ["first name is not present", "..."]    
			#
			# @param entity [Object] the entity instance to be validated.
			# @raise [Veto::InvalidEntity] if the entity is invalid
			def validate! *args
				new(*args).validate!
			end

			private

			def builder
				@builder ||= ::Veto::Builder.new(self)
			end
		end

		# Initializes validator
		#
		# @param entity [Object] the entity instance to validate.
		def initialize entity
			@entity = entity
		end

		# Returns validating entity instance
		# @return [Object]
		def entity
			@entity
		end

		# Returns errors object
		#
        # @return [Veto::Errors]
		def errors
			@errors ||= ::Veto::Errors.new
		end

		# Sets errors to nil. 
		def clear_errors
			@errors = nil
		end

		# Returns boolean value representing the validaty of the entity
		#
        # @return [Boolean]
		def valid?
			execute
			errors.empty?
		end

		# Raises exception if entity is invalid
		#
		# @example
		#   person = Person.new
		#   validator = PersonValidator.new(person)
		#   validator.validate! # => Veto::InvalidEntity, ["first name is not present", "..."]    
		#
		# @raise [Veto::InvalidEntity] if the entity is invalid
		def validate!
			raise(::Veto::InvalidEntity, errors.full_messages) unless valid?
		end

		private

		# Executes validation on the entity
		def execute
			clear_errors
			run_validators
			populate_entity_errors
		end

		# Runs each of the classes configured validators, passing the 
		# validator instance, entity, and errors object as arguments.
		# Each validator will inspect the entity, run validations, and 
		# update the errors object according the the validation rules.
		def run_validators
			self.class.validators.each { |validator| validator.execute(self, entity, errors) }
		end

		# If the entity being validated has an errors accessor defined,
		# assign the errors object to the entity.
		def populate_entity_errors
			if entity.respond_to?(:errors=)
				entity.errors = errors
			end
		end
	end
end