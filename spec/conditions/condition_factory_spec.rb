require 'spec_helper'

describe Veto::ConditionFactory do
  context 'when condition is a string' do
    it 'returns entity eval condition instance' do
      factory.new('a-string').must_be_instance_of(Veto::EntityEvalCondition)
    end
  end

  context 'when condition is a symbol' do
    it 'returns validator method condition instance' do
      factory.new(:a_symbol).must_be_instance_of(Veto::ContextMethodCondition)
    end
  end

  context 'when condition is a proc' do
    it 'returns proc condition instance' do
      factory.new(Proc.new{'blah'}).must_be_instance_of(Veto::ProcCondition)
    end
  end

  context 'when condition is any other general statement or primative' do
    it 'returns primative condition instance' do
      factory.new(true).must_be_instance_of(Veto::PrimativeCondition)
    end
  end

  def factory
    Veto::ConditionFactory
  end
end