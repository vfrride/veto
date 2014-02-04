require 'spec_helper'

describe Veto::FormatCheck do
  context 'when value matches format' do
    it 'assigns no errors' do
      entity = stub(:name => 'abcde')
      errors = new_errors
      check = new_check(:name, :with => /^[a-z]+$/)

      check.call(new_cto(entity, errors))
      errors[:name].must_be_nil
    end
  end

  context 'when value does not match format' do
    it 'assigns errors' do
      entity = stub(:name => 'abcde1')
      errors = new_errors
      check = new_check(:name, :with => /^[a-z]+$/)

      check.call(new_cto(entity, errors))
      errors[:name].must_equal(["is not valid"])
    end
  end

  def new_cto(entity, errors)
    stub(:entity => entity, :errors => errors)
  end

  def new_check(*args)
    Veto::FormatCheck.new(*args)
  end

  def new_errors
    Veto::Errors.new
  end
end