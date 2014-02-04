module Veto
  class ValidateBlock < ConditionalBlock
    def self.build(*args)
      block = new(*args)
      block << MethodCheck.new(block.method_name)
      block
    end

    def initialize(method_name, options={})
      @method_name = method_name
      super(options)
    end

    def method_name
      @method_name
    end
  end
end