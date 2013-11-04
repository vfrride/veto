require 'spec_helper'
require 'veto/validator'

describe Veto::Validator do
	let(:entity){ stub }
	let(:validator_class) { Class.new{ include Veto::Validator } }
	let(:validator) { validator_class.new(entity) } 

	describe '::with_options' do
		it 'returns new builder instance' do
			conditions = stub
			Veto::Builder.expects(:new).with(validator_class, conditions)
			validator_class.with_options(conditions)
		end
	end

	describe '::validates' do
		it 'adds multiple attribute_validators to validators' do
			attribute_validator = stub
			Veto::AttributeValidatorFactory.expects(:new_validator).returns(attribute_validator)
			validator_class.expects(:validate_with).with(attribute_validator)
			validator_class.validates :first_name, :presence => true
		end
	end

	describe '::valid?' do
		it 'initializes new instance and delegates to instance method' do
			validator_class.expects(:new).with(entity).returns(entity)
			entity.expects(:valid?)
			validator_class.valid?(entity)
		end
	end

	describe '::validate!' do
		it 'initializes new instance and delegates to instance method' do
			validator_class.expects(:new).with(entity).returns(entity)
			entity.expects(:validate!)
			validator_class.validate!(entity)
		end
	end

	describe '::validate' do
		it 'adds custom methods validators to validators' do
			custom_method_validator = stub
			Veto::CustomMethodValidator.expects(:new).returns(custom_method_validator).twice
			validator_class.expects(:validate_with).with(custom_method_validator).twice
			validator_class.validate :meth1, :meth2
		end
	end

	describe '#valid?' do
		context 'when entity is valid' do
			it 'returns true' do
				errors = stub(:empty? => true)
				validator.expects(:errors => errors)
				validator.valid?.must_equal true
			end
		end

		context 'when entity is invalid' do
			it 'returns false' do
				errors = stub(:empty? => false)
				validator.expects(:errors => errors)
				validator.valid?.must_equal false
			end
		end
	end

	describe '#validate!' do
		context 'when entity is valid' do
			it 'returns true' do
				validator.expects(:valid?).returns(true)
				validator.validate!.must_be_nil
			end
		end

		context 'when entity is invalid' do
			it 'returns false' do
				errors = stub(:full_messages => '')
				validator.expects(:valid?).returns(false)
				validator.expects(:errors => errors)
				proc { validator.validate! }.must_raise ::Veto::InvalidEntity
			end
		end
	end

	describe '#errors' do
		it 'returns errors object' do
			validator.errors.must_be_instance_of Veto::Errors
		end
	end
end