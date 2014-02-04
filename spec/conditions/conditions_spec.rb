require 'spec_helper'

describe Veto::Conditions do
  it 'accepts single option' do
    group = new_conditions(:good_method?)
    group.size.must_equal(1)
  end

  it 'accepts array of options' do
    group = new_conditions([:good_method?, Proc.new{ 'blah' }])
    group.size.must_equal(2)
  end

  it 'iterates through conditions' do
    group = new_conditions([:good_method?, Proc.new{ 'blah' }])
    condition_list = []

    group.each {|c| condition_list << c.class.name }
    condition_list.must_equal(["Veto::ContextMethodCondition", "Veto::ProcCondition"])
  end

  def new_conditions(*args)
    Veto::Conditions.new(*args)
  end
end