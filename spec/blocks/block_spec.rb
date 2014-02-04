require 'spec_helper'

describe Veto::Block do
  it 'can have children assigned' do
    block = new_block
    child = stub
    block << child
    block.children.must_equal([child])
  end

  it 'can :call each child' do
    block = new_block
    
    child1 = stub
    child2 = stub

    block << child1
    block << child2

    args = stub

    child1.expects(:call).with(args).once
    child2.expects(:call).with(args).once

    block.call(args)
  end

  def new_block
    Veto::Block.new
  end
end