require 'spec_helper'

describe Veto::ValidateBlock do
  it 'can build itself and assign check child' do
    block = Veto::ValidateBlock.build(:good_method?, :if => true)
    block.children.size.must_equal(1)
    block.children[0].must_be_instance_of(Veto::MethodCheck)
  end

  it 'has method_name' do
    block = new_block(:good_method?)
    block.method_name.must_equal(:good_method?)
  end

  def new_block(*args)
    Veto::ValidateBlock.new(*args)
  end
end