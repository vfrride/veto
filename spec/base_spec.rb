require 'spec_helper'
require 'veto/base'

describe Veto::Base do
	let(:entity){ stub }
	let(:validator) { Veto::Base.new(stub) } 

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
end