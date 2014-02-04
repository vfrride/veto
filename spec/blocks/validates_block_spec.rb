require 'spec_helper'

describe Veto::ValidatesBlock do
  it 'gets attribute_name' do
    block = new_block(:first_name, :presence => true, :if => true)
    block.attribute_name.must_equal(:first_name)
  end

  it 'can build nested check structure' do
    block = build_block(:first_name, :presence => true, :format => /[a-z]/, :if => true)
    block.children.size.must_equal(2)
    block.children[0].must_be_instance_of(Veto::ValidatesBlock::CheckBlock)
  end

  def new_block(*args)
    Veto::ValidatesBlock.new(*args)
  end

  def build_block(*args)
    Veto::ValidatesBlock.build(*args)
  end
end