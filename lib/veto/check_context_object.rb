module Veto
  class CheckContextObject
    attr_reader :entity, :context, :errors
    def initialize(entity, context, errors)
      @entity = entity
      @context = context
      @errors = errors
    end
  end
end