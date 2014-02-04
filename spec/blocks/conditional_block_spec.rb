require 'spec_helper'

describe Veto::ConditionalBlock do
  it 'exposes options with conditions removed' do
    block = new_block(:if => 'blah', :opt1 => 'blahblah')
    block.options.must_equal(:opt1 => 'blahblah')
  end

  context 'when conditions pass' do
    it 'will :call children' do
      block = new_block(:if => true, :opt1 => 'blahblah')
      child = stub

      block << child

      child.expects(:call).once
      block.call
    end
  end

  context 'when conditions fail' do
    it 'will not :call children' do
      block = new_block(:if => false, :opt1 => 'blahblah')
      child = stub

      block << child

      child.expects(:call).never
      block.call
    end
  end

  def new_block(*args)
    Veto::ConditionalBlock.new(*args)
  end
end