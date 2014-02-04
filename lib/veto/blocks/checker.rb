module Veto
  class Checker < Block
    def self.from_children(children=[])
      inst = new
      children.each{|child| inst << child }
      inst
    end

    def initialize(&block)
      super
      instance_eval(&block) if block_given?
    end

    def validates(*args)
      self << ValidatesBlock.build(*args)
    end

    def validate(*args)
      self << ValidateBlock.build(*args)
    end

    def with_options(*args, &block)
      b = WithOptionsBlock.build(*args)
      b << self.class.new(&block)
      self << b
    end
  end
end