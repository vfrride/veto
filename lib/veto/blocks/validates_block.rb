module Veto
  class ValidatesBlock < ConditionalBlock
    class CheckBlock < ConditionalBlock
      def self.build(*args)
        block = new(*args)
        block << ::Veto::CheckFactory.new(block.type, block.attribute_name, block.options)
        block
      end

      def initialize(type, attribute_name, value_or_options=nil)
        @type = type
        @attribute_name = attribute_name
        options =         
          case value_or_options
          when TrueClass
            {}
          when Hash
            value_or_options
          when Range, Array
            {:in => value_or_options}
          else
            {:with => value_or_options}
          end
        super(options)
      end

      def attribute_name
        @attribute_name
      end

      def type
        @type
      end
    end

    def self.build(*args)
      block = new(*args)
      block.options.each {|k,v| block << CheckBlock.build(k, block.attribute_name, v)}
      block
    end

    def initialize(attribute_name, options={})
      @attribute_name = attribute_name
      super(options)
    end

    def attribute_name
      @attribute_name
    end
  end
end