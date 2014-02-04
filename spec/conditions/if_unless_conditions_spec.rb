require 'spec_helper'

describe Veto::IfUnlessConditions do
  context 'when passing conditions' do
    it 'correctly evaluates conditions' do
      circle   = stub(:is_round? => true, :can_roll? => true, :has_corners? => false, :is_stackable? => false)
      cco      = stub(:entity => circle)

      condition = new_if_unless_conditions(
        :if => 'can_roll?',
        :unless => 'has_corners?'
      )
      condition.pass?(cco).must_equal(true)
    end
  end

  context 'when failing conditions' do
    it 'correctly evaluates conditions' do
      circle   = stub(:is_round? => true, :can_roll? => true, :has_corners? => false, :is_stackable? => false)
      cco      = stub(:entity => circle)

      condition = new_if_unless_conditions(
        :if => 'has_corners?',
        :unless => 'can_roll?'
      )
      condition.pass?(cco).must_equal(false)
    end
  end

  def new_if_unless_conditions(*args)
    Veto::IfUnlessConditions.new(*args)
  end
end