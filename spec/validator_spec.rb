require 'spec_helper'

describe Veto::Validator do
  describe 'general usage' do
    context 'when validation fails' do
      it 'it can generate errors' do
        entity = stub(:name => nil)
        validator = new_validator(:validates, :name, :presence => true)
        validator.valid?(entity)
        validator.errors[:name].must_equal(["is not present"])
      end

      it 'it can validate entity strictly' do
        entity = stub(:name => nil)
        validator = new_validator(:validates, :name, :presence => true)
        proc { validator.validate!(entity) }.must_raise(Veto::InvalidEntity)
      end
    end

    def new_validator(*args)
      klass = Class.new{ include Veto.validator }
      klass.send(*args)
      klass.new
    end
  end

  describe 'validates dsl' do
    context 'when group conditions pass' do
      context 'when check conditions pass' do
        it 'assign errors' do
          entity = stub(:name => nil)
          validator = new_validator(:validates, :name, :presence => {:if => true}, :if => true)
          validator.valid?(entity)
          validator.errors[:name].must_equal(["is not present"])
        end
      end

      context 'when check conditions fail' do
        it 'does not assign errors' do
          entity = stub(:name => nil)
          validator = new_validator(:validates, :name, :presence => {:if => false}, :if => true)
          validator.valid?(entity)
          validator.errors.must_be_empty
        end
      end
    end

    context 'when group conditions fail' do
      it 'assign errors' do
        entity = stub(:name => nil)
        validator = new_validator(:validates, :name, :presence => {:if => true}, :if => false)
        validator.valid?(entity)
        validator.errors.must_be_empty
      end
    end

    describe 'attribute validation' do
      it 'assign errors' do
        entity = stub(:isbn => '23432-53444-3234234')
        validator = new_validator(:validates, :isbn, :exact_length => 13)
        validator.valid?(entity)
        validator.errors[:isbn].must_equal(["is not 13 characters"])
      end
    end

    describe 'format check' do
      context 'when value matches format' do
        it 'assigns no errors' do
          entity = stub(:first_name => 'john')
          validator = new_validator(:validates, :first_name, :format => /[A-Za-z]+/)
          validator.valid?(entity)
          validator.errors.must_be_empty
        end
      end

      context 'when value does not match format' do
        it 'assigns errors' do
          entity = stub(:first_name => 'john')
          validator = new_validator(:validates, :first_name, :format => /[0-9]+/)
          validator.valid?(entity)
          validator.errors[:first_name].must_equal(["is not valid"])
        end
      end
    end

    def new_validator(*args)
      klass = Class.new{ include Veto.validator }
      klass.send(*args)
      klass.new
    end
  end

  describe 'validate dsl' do
    context 'when conditions pass' do
      context 'when check passes' do
        it 'does not assign errors' do
          entity = stub(:validate? => true, :first_name => 'John')
          validator = new_validator
          validator.valid?(entity)
          validator.errors.must_be_empty
        end
      end

      context 'when check fails' do
        it 'assigns errors' do
          entity = stub(:validate? => true, :first_name => 'Bob')
          validator = new_validator
          validator.valid?(entity)
          validator.errors.must_equal(:first_name=>["is has wrong length"])
        end
      end
    end

    context 'when conditions fail' do
      it 'does not assign errors' do
        entity = stub(:validate? => false, :first_name => 'John')
        validator = new_validator
        validator.valid?(entity)
        validator.errors.must_be_empty
      end
    end

    def new_validator
      Class.new {
        include Veto.validator

        validate :validate_first_name_length, :if => 'validate?'

        def validate_first_name_length(entity)
          errors.add(:first_name, 'is has wrong length') unless entity.first_name.size == 4
        end
      }.new
    end
  end

  describe 'with_options dsl' do
    context 'when conditions pass' do
      it 'runs checks inside block' do
        entity = stub(:validate? => true, :first_name => nil, :last_name => nil)
        validator = new_validator
        validator.valid?(entity)
        validator.errors.must_equal(:first_name=>["is not present"], :last_name=>["is not present"])
      end
    end

    context 'when conditions fail' do
      it 'does not run checks inside block' do
        entity = stub(:validate? => false, :first_name => nil, :last_name => nil)
        validator = new_validator
        validator.valid?(entity)
        validator.errors.must_be_empty
      end
    end

    def new_validator
      Class.new {
        include Veto.validator

        with_options :if => 'validate?' do
          validates :first_name, :presence => true
          validates :last_name, :presence => true
        end
      }.new
    end
  end

  describe 'custom validator' do
    it 'uses custom validator' do
      validator = Class.new {
        include Veto.validator

        class EmailCheck < ::Veto::AttributeCheck
          def check(attribute_name, value, errors, options)
            unless value.to_s =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
              errors.add(attribute_name, "is not a valid email address")
            end
          end
        end

        validates :email_address, :email => true
      }.new

      entity = stub(:email_address => 123)
      validator.valid?(entity)
      validator.errors.must_equal(:email_address=>["is not a valid email address"])
    end
  end

  describe 'validator descendents/inheritence' do
    it 'inherits superclass validation rules' do
      super_class = Class.new{
        include Veto.validator

        validate :create_superclass_error

        def create_superclass_error(entity)
          errors.add(:base, "superclass error")
        end
      }

      sub_class1 = Class.new(super_class){

        validate :create_subclass_error

        def create_subclass_error(entity)
          errors.add(:base, "subclass1 error")
        end
      }

      sub_class2 = Class.new(super_class){

        validate :create_subclass_error

        def create_subclass_error(entity)
          errors.add(:base, "subclass2 error")
        end
      }

      validator = sub_class1.new
      validator.valid?(stub)
      validator.errors.must_equal(:base=>["superclass error", "subclass1 error"])

      validator = sub_class2.new
      validator.valid?(stub)
      validator.errors.must_equal(:base=>["superclass error", "subclass2 error"])
    end
  end
end