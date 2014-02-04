require 'spec_helper'

describe Veto::InclusionCheck do
  context 'when value is included' do
    it 'assigns no errors' do
      entity = stub(:name => 'cat')
      errors = new_errors
      check = new_check(:name, :in => %w(cat dog mouse))

      check.call(new_cto(entity, errors))
      errors[:name].must_be_nil
    end
  end

  context 'when value is not included' do
    it 'assigns no errors' do
      entity = stub(:name => 'cat')
      errors = new_errors
      check = new_check(:name, :in => %w(dog mouse))

      check.call(new_cto(entity, errors))
      errors[:name].must_equal(["is not in set: [\"dog\", \"mouse\"]"])
    end
  end

  def new_cto(entity, errors)
    stub(:entity => entity, :errors => errors)
  end

  def new_check(*args)
    Veto::InclusionCheck.new(*args)
  end

  def new_errors
    Veto::Errors.new
  end
end