module Veto
  module Validator
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def with_options(*args, &block)
        checker.with_options(*args, &block)
      end

      def validates(*args)
        checker.validates(*args)
      end

      def validate(*args)
        checker.validate(*args)
      end

      def check_with(val)
        @checker = val
      end

      def checker
        @checker ||= build_checker
      end

      private

      def build_checker(children=[])
        Checker.from_children(children)
      end

      def inherited(descendant)
        descendant.check_with(build_checker(checker.children.dup))
      end
    end

    def errors
      @errors ||= ::Veto::Errors.new
    end

    def valid?(entity)
      validate(entity)
      errors.empty?
    end

    def validate!(entity)
      raise(::Veto::InvalidEntity, errors) unless valid?(entity)
    end

    private

    def clear_errors
      @errors = nil
    end

    def validate(entity)
      clear_errors
      self.class.checker.call(CheckContextObject.new(entity, self, errors))
      populate_entity_errors(entity)
    end

    def populate_entity_errors(entity)
      if entity.respond_to?(:errors=)
        entity.errors = errors
      end
    end
  end
end