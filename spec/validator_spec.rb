require 'spec_helper'
require 'veto/validator'

describe Veto::Validator do
	let(:entity){ stub }
	let(:validator_class) { Class.new{ include Veto::Validator } }
	let(:validator) { validator_class.new(entity) } 

	describe '::with_options' do
		let(:builder){stub}
		let(:args){stub}

		it 'delegates method to builder' do
			validator_class.expects(:builder).returns(builder)
			builder.expects(:with_options).with(args)
			validator_class.with_options(args)
		end
	end

	describe '::validates' do
		let(:builder){stub}
		let(:args){stub}

		it 'delegates method to builder' do
			validator_class.expects(:builder).returns(builder)
			builder.expects(:validates).with(args)
			validator_class.validates(args)
		end
	end

	describe '::validate' do
		let(:builder){stub}
		let(:args){stub}

		it 'delegates method to builder' do
			validator_class.expects(:builder).returns(builder)
			builder.expects(:validate).with(args)
			validator_class.validate(args)
		end
	end

	describe '::validator_list' do
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

	describe '::with_options' do
	end

	describe '::validates' do
	end

	describe '::builder' do
		it 'is private method' do
			proc{validator_class.builder}.must_raise NoMethodError
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