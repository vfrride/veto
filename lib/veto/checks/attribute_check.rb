module Veto
  class AttributeCheck < Check
    def initialize(attribute_name, options={})
      @attribute_name = attribute_name
      @options = options
    end

    def call(cco)
      value = cco.entity.public_send(@attribute_name)
      check(@attribute_name, value, cco.errors, @options)
    end

    private

    def check(attribute_name, value, errors, options)
      raise(NotImplementedError)
    end
  end
end