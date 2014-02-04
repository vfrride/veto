require 'spec_helper'

describe Veto::IntegerCheck do
  context 'when value is an integer' do
    it 'assigns no errors' do
      entity = stub(:name => 23)
      errors = new_errors
      check = new_check(:name)

      check.call(new_cto(entity, errors))
      errors[:name].must_be_nil
    end
  end

  context 'when value is not an integer' do
    it 'assigns no errors' do
      entity = stub(:name => 'abc')
      errors = new_errors
      check = new_check(:name)

      check.call(new_cto(entity, errors))
      errors[:name].must_equal(["is not a number"])
    end
  end

  def new_cto(entity, errors)
    stub(:entity => entity, :errors => errors)
  end

  def new_check(*args)
    Veto::IntegerCheck.new(*args)
  end

  def new_errors
    Veto::Errors.new
  end
end