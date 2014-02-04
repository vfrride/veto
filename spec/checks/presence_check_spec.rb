require 'spec_helper'

describe Veto::PresenceCheck do
  context 'when value is not null' do
    it 'assigns no errors' do
      entity = stub(:name => 'abcde')
      errors = new_errors
      check = new_check(:name)

      check.call(new_cto(entity, errors))
      errors[:name].must_be_nil
    end
  end

  context 'when value is blank' do
    it 'assigns no errors' do
      entity = stub(:name => '')
      errors = new_errors
      check = new_check(:name)

      check.call(new_cto(entity, errors))
      errors[:name].must_equal(["is not present"])
    end
  end

  context 'when value null' do
    it 'assigns no errors' do
      entity = stub(:name => nil)
      errors = new_errors
      check = new_check(:name)

      check.call(new_cto(entity, errors))
      errors[:name].must_equal(["is not present"])
    end
  end

  def new_cto(entity, errors)
    stub(:entity => entity, :errors => errors)
  end

  def new_check(*args)
    Veto::PresenceCheck.new(*args)
  end

  def new_errors
    Veto::Errors.new
  end
end