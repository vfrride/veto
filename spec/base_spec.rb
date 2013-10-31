require 'spec_helper'
require 'veto/base'

describe Veto::Base do
	let(:entity){ stub }
	let(:validator) { Veto::Base.new(stub) } 

	describe '::with_options' do
		let(:builder){stub}
		let(:args){stub}

		it 'delegates method to builder' do
			Veto::Base.expects(:builder).returns(builder)
			builder.expects(:with_options).with(args)
			Veto::Base.with_options(args)
		end
	end

	describe '::validates' do
		let(:builder){stub}
		let(:args){stub}

		it 'delegates method to builder' do
			Veto::Base.expects(:builder).returns(builder)
			builder.expects(:validates).with(args)
			Veto::Base.validates(args)
		end
	end

	describe '::validate' do
		let(:builder){stub}
		let(:args){stub}

		it 'delegates method to builder' do
			Veto::Base.expects(:builder).returns(builder)
			builder.expects(:validate).with(args)
			Veto::Base.validate(args)
		end
	end

	describe '::validator_list' do
	end

	describe '::valid?' do
		it 'initializes new instance and delegates to instance method' do
			Veto::Base.expects(:new).with(entity).returns(entity)
			entity.expects(:valid?)
			Veto::Base.valid?(entity)
		end
	end

	describe '::validate!' do
		it 'initializes new instance and delegates to instance method' do
			Veto::Base.expects(:new).with(entity).returns(entity)
			entity.expects(:validate!)
			Veto::Base.validate!(entity)
		end
	end

	describe '::with_options' do
	end

	describe '::validates' do
	end

	describe '::builder' do
		it 'is private method' do
			proc{Veto::Base.builder}.must_raise NoMethodError
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