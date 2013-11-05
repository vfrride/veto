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

			def validate_with *objs
				validators.concat objs.flatten
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

			private

			def builder
				@builder ||= ::Veto::Builder.new(self)
			end
		end

		def initialize entity
			@entity = entity
		end

		def entity
			@entity
		end

		def errors
			@errors ||= ::Veto::Errors.new
		end

		def clear_errors
			@errors = nil
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