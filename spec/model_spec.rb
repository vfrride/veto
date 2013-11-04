require 'spec_helper'
require 'veto/model'

describe Veto::Model do
	let(:validator){stub}
	let(:validator_class){stub(:new => validator)}
	let(:entity_class) {  
		klass = Class.new{
			include Veto::Model
			attr_accessor :first_name, :last_name
		}
		klass.validates_with validator_class
		klass
	}
	let(:entity){ entity_class.new }

	describe '::validates_with' do
		it 'assigns validator' do
			obj = Object.new
			entity_class.validates_with obj
			entity_class.validator.must_equal obj
		end
	end

	describe '::validator' do
		context 'when validator is assigned' do
			it 'returns validator' do
				entity_class.validator.must_equal validator_class
			end
		end

		context 'when validator is not assigned' do
			before { entity_class.validates_with nil }

			it 'raises error' do
				proc{ entity_class.validator }.must_raise ::Veto::CheckerNotAssigned
			end
		end
	end

	describe '#validator' do
		it 'initializes, memoizes, and returns validator instance' do
			entity.send(:validator).must_equal validator
		end
	end

	describe '#errors' do
		it 'delegates method to validator' do
			validator.expects(:errors)
			entity.errors
		end
	end

	describe '#valid?' do
		it 'delegates method to validator' do
			validator.expects(:valid?)
			entity.valid?
		end
	end

	describe '#validate!' do
		it 'delegates method to validator' do
			validator.expects(:validate!)
			entity.validate!
		end
	end
end