require 'spec_helper'

describe Veto::ProcCondition do
  context 'when proc returns truthy value' do
    it 'passes' do
      entity = stub(:good? => true)
      cco = stub(:entity => entity)
      condition = new_condition(Proc.new{|e| e.good? })
      condition.pass?(cco).must_equal(true)
    end
  end

  context 'when proc returns falsy value' do
    it 'fails' do
      entity = stub(:good? => false)
      cco = stub(:entity => entity)
      condition = new_condition(Proc.new{|e| e.good? })
      condition.pass?(cco).must_equal(false)
    end
  end
  
  def new_condition(*args)
    Veto::ProcCondition.new(*args)
  end
end