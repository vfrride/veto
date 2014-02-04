require 'spec_helper'

describe Veto::ExactLengthCheck do
  context 'when value is exact length' do
    it 'assigns no errors' do
      entity = stub(:name => 'abcde')
      errors = new_errors
      check = new_check(:name, :with => 5)

      check.call(new_cto(entity, errors))
      errors[:name].must_be_nil
    end
  end

  context 'when value is not exact length' do
    it 'assigns errors' do
      entity = stub(:name => 'abcde')
      errors = new_errors
      check = new_check(:name, :with => 4)

      check.call(new_cto(entity, errors))
      errors[:name].must_equal(['is not 4 characters'])
    end
  end

  def new_cto(entity, errors)
    stub(:entity => entity, :errors => errors)
  end

  def new_check(*args)
    Veto::ExactLengthCheck.new(*args)
  end

  def new_errors
    Veto::Errors.new
  end
end