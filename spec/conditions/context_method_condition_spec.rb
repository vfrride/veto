require 'spec_helper'

describe Veto::ContextMethodCondition do
  context 'when context method returns truthy value' do
    it 'passes' do
      context = stub(:is_good? => true)
      cco = stub(:context => context, :entity => stub)
      condition = new_condition(:is_good?)
      condition.pass?(cco).must_equal(true)
    end
  end

  context 'when context method returns falsy value' do
    it 'fails' do
      context = stub(:is_good? => false)
      cco = stub(:context => context, :entity => stub)
      condition = new_condition(:is_good?)
      condition.pass?(cco).must_equal(false)
    end
  end

  def new_condition(*args)
    Veto::ContextMethodCondition.new(*args)
  end
end