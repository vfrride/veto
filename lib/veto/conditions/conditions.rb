require 'forwardable'

module Veto
  class Conditions < Condition
    extend Forwardable

    def_delegators :conditions, :each, :size

    def initialize(options_list=[])
      @options_list = options_list
    end

    private

    def conditions
      options_list.map{|options| ConditionFactory.new(options) }
    end

    def options_list
      [*@options_list]
    end
  end
end
