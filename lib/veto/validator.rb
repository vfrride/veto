require 'veto/errors'
require 'veto/exceptions'
require 'veto/blocks/list_block'
require 'veto/builder'

module Veto
	module Validator
		def self.included(base)
			base.extend ClassMethods
		end

		module ClassMethods
			def validator_list
				@validator_list ||= ::Veto::ListBlock.new
			end

			def with_options *args, &block
				builder.with_options(*args, &block)
			end

			def validates *args
				builder.validates(*args)
			end		

			def validate *args
				builder.validate(*args)
			end

			def valid? entity
				new(entity).valid?
			end

			def validate! entity
				new(entity).validate!
			end

			private

			def builder
				::Veto::Builder.new(validator_list)
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
			self.class.validator_list.execute(self, entity)
			populate_entity_errors
		end

		def populate_entity_errors
			entity.errors = errors if entity.respond_to?(:errors=)
		end
	end
end