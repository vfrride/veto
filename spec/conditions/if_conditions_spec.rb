require 'spec_helper'

describe Veto::IfConditions do
  context 'with passing condition' do
    it 'correctly evalutes conditions' do
      circle          = stub(:is_round? => true, :can_roll? => true, :has_corners? => false, :is_stackable? => false)
      cco             = stub(:entity => circle)
      eval_condition  = 'can_roll?'                           # pass

      condition = new_conditions(eval_condition)
      condition.pass?(cco).must_equal(true)
    end
  end

  context 'with failing condition' do
    it 'correctly evalutes conditions' do
      circle          = stub(:is_round? => true, :can_roll? => true, :has_corners? => false, :is_stackable? => false)
      cco             = stub(:entity => circle)
      eval_condition  = 'is_stackable?'                       # fail

      condition = new_conditions(eval_condition)
      condition.pass?(cco).must_equal(false)
    end
  end

  context 'with passing conditions' do
    it 'correctly evalutes conditions' do
      circle          = stub(:is_round? => true, :can_roll? => true, :has_corners? => false, :is_stackable? => false)
      cco             = stub(:entity => circle)
      proc_condition  = Proc.new{|entity| entity.is_round?}   # pass
      eval_condition  = 'can_roll?'                           # pass

      condition = new_conditions([proc_condition, eval_condition])
      condition.pass?(cco).must_equal(true)
    end
  end

  context 'with one passing and one failing condition' do
    it 'correctly evalutes conditions' do
      circle          = stub(:is_round? => true, :can_roll? => true, :has_corners? => false, :is_stackable? => false)
      cco             = stub(:entity => circle)
      proc_condition  = Proc.new{|entity| entity.is_round?}    # pass
      eval_condition  = 'has_corners?'                         # fail

      condition = new_conditions([proc_condition, eval_condition])
      condition.pass?(cco).must_equal(false)
    end
  end

  context 'with failing conditions' do
    it 'correctly evalutes conditions' do
      circle          = stub(:is_round? => true, :can_roll? => true, :has_corners? => false, :is_stackable? => false)
      cco             = stub(:entity => circle)
      proc_condition  = Proc.new{|entity| entity.has_corners?}  # fail
      eval_condition  = 'is_stackable?'                         # fail

      condition = new_conditions([proc_condition, eval_condition])
      condition.pass?(cco).must_equal(false)
    end
  end

  def new_conditions(*args)
    Veto::IfConditions.new(*args)
  end
end