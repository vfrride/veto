require 'spec_helper'

describe Veto::ValidatesBlock::CheckBlock do
  it 'gets attribute_name' do
    block = new_block(:presence, :first_name, true)
    block.attribute_name.must_equal(:first_name)
  end

  it 'gets type' do
    block = new_block(:presence, :first_name, true)
    block.type.must_equal(:presence)
  end

  it 'converts true value to hash' do
    block = new_block(:presence, :first_name, true)
    block.options.must_equal({})
  end

  it 'converts range value to hash' do
    block = new_block(:presence, :first_name, 1..9)
    block.options.must_equal(:in => 1..9)
  end

  it 'converts array value to hash' do
    block = new_block(:presence, :first_name, ['cat', 'dog'])
    block.options.must_equal(:in => ['cat', 'dog'])
  end

  it 'converts other value to hash' do
    block = new_block(:presence, :first_name, 23)
    block.options.must_equal(:with => 23)
  end

  it 'can build structure and assign check child' do
    block = build_block(:presence, :first_name, true)
    block.children.map{|c| c.class.name}.must_equal(["Veto::PresenceCheck"])
  end

  def new_block(*args)
    Veto::ValidatesBlock::CheckBlock.new(*args)
  end

  def build_block(*args)
    Veto::ValidatesBlock::CheckBlock.build(*args)
  end
end