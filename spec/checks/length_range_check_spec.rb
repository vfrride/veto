require 'spec_helper'

describe Veto::LengthRangeCheck do
  context 'when value in length range' do
    it 'assigns no errors' do
      entity = stub(:name => 'abcdef')
      errors = new_errors
      check = new_check(:name, :in => 1..10)

      check.call(new_cto(entity, errors))
      errors[:name].must_be_nil
    end
  end

  context 'when value not in length range' do
    it 'assigns no errors' do
      entity = stub(:name => 'abcdef')
      errors = new_errors
      check = new_check(:name, :in => 99..199)

      check.call(new_cto(entity, errors))
      errors[:name].must_equal(["is too short or too long"])
    end
  end

  def new_cto(entity, errors)
    stub(:entity => entity, :errors => errors)
  end

  def new_check(*args)
    Veto::LengthRangeCheck.new(*args)
  end

  def new_errors
    Veto::Errors.new
  end
end