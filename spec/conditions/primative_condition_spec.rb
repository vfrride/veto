require 'spec_helper'

describe Veto::PrimativeCondition do
  context 'when input coerses to true' do
    it 'passes' do
      new_condition(true).pass?.must_equal(true)
      new_condition('string').pass?.must_equal(true)
      new_condition(:symbol).pass?.must_equal(true)
    end
  end

  context 'when input coerses to false' do
    it 'fails' do
      new_condition(false).pass?.must_equal(false)
      new_condition('blah' == 'blahblah').pass?.must_equal(false)
    end
  end

  def new_condition(*args)
    Veto::PrimativeCondition.new(*args)
  end
end