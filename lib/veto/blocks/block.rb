module Veto
  class Block
    def initialize
      @children = []
    end

    def call(*args)
      call_children(*args)
    end

    def <<(child)
      @children << child
    end

    def children
      @children
    end

    private

    def call_children(*args)
      children.each {|child| child.call(*args)}
    end
  end
end