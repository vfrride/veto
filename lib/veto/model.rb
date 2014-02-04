module Veto
  module Model
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def validates_with(veto_validator)
        @validator = veto_validator
      end

      def validator
        @validator || raise(::Veto::ValidatorNotAssigned, 'validator not assigned')
      end
    end

    def valid?
      validator.valid?(self)
    end

    def validate!
      validator.validate!(self)
    end

    def errors
      validator.errors
    end

    private

    def validator
      self.class.validator
    end
  end
end