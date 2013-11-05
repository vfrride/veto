require 'spec_helper'
require 'veto/validator'

describe Veto::Validator do
	let(:entity){ stub }
	let(:validator_class) { Class.new{ include Veto::Validator } }
	let(:validator) { validator_class.new(entity) } 

	describe '::builder' do
		it 'returns builder' do
			validator_class.send(:builder).must_be_instance_of Veto::Builder
		end
	end

	describe '::with_options' do
		it 'delegates to builder' do
			builder = stub
			validator_class.expects(:builder).returns(builder)
			builder.expects(:with_options).with('args')
			validator_class.with_options('args')
		end
	end

	describe '::validates' do
		it 'delegates to builder' do
			builder = stub
			validator_class.expects(:builder).returns(builder)
			builder.expects(:validates).with('args')
			validator_class.validates('args')
		end	
	end

	describe '::validate' do
		it 'delegates to builder' do
			builder = stub
			validator_class.expects(:builder).returns(builder)
			builder.expects(:validate).with('args')
			validator_class.validate('args')
		end	
	end

	describe '::validate_with' do
		it 'adds validator to validators array' do
			validator = stub
			validator_class.validate_with validator
			validator_class.validators.must_equal [validator]
		end

		it 'adds validators to validators array' do
			validator = stub
			validator_class.validate_with [validator, validator]
			validator_class.validators.must_equal [validator, validator]
		end
	end

	describe '::validators' do
		it 'returns validators list' do
			validator_class.validators.must_equal []
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