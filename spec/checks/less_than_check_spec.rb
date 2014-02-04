require 'spec_helper'

describe Veto::LessThanCheck do
  context 'when value is less than' do
    it 'assigns no errors' do
      entity = stub(:name => 22)
      errors = new_errors
      check = new_check(:name, :with => 23)

      check.call(new_cto(entity, errors))
      errors[:name].must_be_nil
    end
  end

  context 'when value is equal' do
    it 'assigns no errors' do
      entity = stub(:name => 23)
      errors = new_errors
      check = new_check(:name, :with => 23)

      check.call(new_cto(entity, errors))
      errors[:name].must_equal(["must be less than 23"])
    end
  end

  context 'when value is greater than' do
    it 'assigns no errors' do
      entity = stub(:name => 24)
      errors = new_errors
      check = new_check(:name, :with => 23)

      check.call(new_cto(entity, errors))
      errors[:name].must_equal(["must be less than 23"])
    end
  end

  def new_cto(entity, errors)
    stub(:entity => entity, :errors => errors)
  end

  def new_check(*args)
    Veto::LessThanCheck.new(*args)
  end

  def new_errors
    Veto::Errors.new
  end
end