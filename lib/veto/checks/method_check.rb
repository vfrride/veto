module Veto
  class MethodCheck < Check
    def initialize(method_name)
      @method_name = method_name
    end

    def call(cco)
      cco.context.send(@method_name, cco.entity)
    end

    private

    def check(attribute_name, value, errors, options)
      raise(NotImplementedError)
    end
  end
end