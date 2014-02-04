module Veto
  class CheckFactory
    def self.new(type, attribute_name, options={})
      class_name = "#{camel_case(type.to_s)}Check"
      begin
        Veto.const_get(class_name).new(attribute_name, options)
      rescue NameError => e
        raise(CheckNotAssigned, "Check not found: ::Veto::#{class_name}")
      end
    end

    private

    def self.camel_case(str)
      str.split('_').map{|w| w.capitalize }.join('')
    end
  end
end