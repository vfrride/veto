require 'veto/errors'
require 'veto/blocks/list_block'
require 'veto/builder'
require 'veto/exceptions'

module Veto
	class Base
		class << self
			def with_options *args
				builder.with_options(*args)
			end

			def validates *args
				builder.validates(*args)
			end		

			def validate *args
				builder.validate(*args)
			end

			def validator_list
				@validator_list ||= ::Veto::ListBlock.new
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

		attr_reader :entity

		def initialize entity
			@entity = entity
		end

		def errors
			@errors ||= ::Veto::Errors.new
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
			@errors = ::Veto::Errors.new
			self.class.validator_list.execute(self, entity)
		end
	end
end