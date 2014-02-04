require 'spec_helper'

describe Veto::EntityEvalCondition do
  it 'passes when entity evals to truthy value' do
    entity = stub(:today_is_good => 'yup')
    cco = stub(:entity => entity)
    condition = new_condition('today_is_good')
    condition.pass?(cco).must_equal(true)
  end

  it 'fails when entity evals to falsy value' do
    entity = stub(:today_is_good => false)
    cco = stub(:entity => entity)
    condition = new_condition('today_is_good')
    condition.pass?(cco).must_equal(false)
  end

  def new_condition(*args)
    Veto::EntityEvalCondition.new(*args)
  end
end