require 'spec_helper'

describe Veto::MinLengthCheck do
  context 'when value is greater than min length' do
    it 'assigns no errors' do
      entity = stub(:name => 'abcdefgh')
      errors = new_errors
      check = new_check(:name, :with => 5)

      check.call(new_cto(entity, errors))
      errors[:name].must_be_nil
    end
  end

  context 'when value equals min length' do
    it 'assigns no errors' do
      entity = stub(:name => 'abcde')
      errors = new_errors
      check = new_check(:name, :with => 5)

      check.call(new_cto(entity, errors))
      errors[:name].must_be_nil
    end
  end

  context 'when value is less than min length' do
    it 'assigns no errors' do
      entity = stub(:name => 'abcdefgh')
      errors = new_errors
      check = new_check(:name, :with => 99)

      check.call(new_cto(entity, errors))
      errors[:name].must_equal(["is shorter than 99 characters"])
    end
  end

  def new_cto(entity, errors)
    stub(:entity => entity, :errors => errors)
  end

  def new_check(*args)
    Veto::MinLengthCheck.new(*args)
  end

  def new_errors
    Veto::Errors.new
  end
end