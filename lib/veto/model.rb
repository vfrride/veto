require 'veto/exceptions'

module Veto
	module Model
		def self.included(base)
			base.extend ClassMethods
		end

		module ClassMethods
			def validates_with veto_checker
				@validator = veto_checker
			end

			def validator
				@validator || raise(::Veto::CheckerNotAssigned, 'validator not assigned')
			end
		end

		def valid?
			validator.valid?
		end

		def validate!
			validator.validate!
		end

		def errors
			validator.errors
		end

		private

		def validator
			@validator ||= self.class.validator.new(self)
		end
	end
end