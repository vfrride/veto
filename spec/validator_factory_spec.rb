require 'spec_helper'
require 'veto/validator_factory'

describe Veto::ValidatorFactory do
	let(:factory) { Veto::ValidatorFactory }
	let(:type) { :presence }

	describe '::new_validator' do
		let(:result) { factory.new_validator(type, stub, stub) }
	
		context 'when type is exact_length' do
			let(:type) { :exact_length }
			it { result.must_be_instance_of Veto::ExactLengthValidator }
		end

		context 'when type is format' do
			let(:type) { :format }
			it { result.must_be_instance_of Veto::FormatValidator }
		end

		context 'when type is inclusion' do
			let(:type) { :inclusion }
			it { result.must_be_instance_of Veto::InclusionValidator }
		end

		context 'when type is integer' do
			let(:type) { :integer }
			it { result.must_be_instance_of Veto::IntegerValidator }
		end

		context 'when type is length_range' do
			let(:type) { :length_range }
			it { result.must_be_instance_of Veto::LengthRangeValidator }
		end

		context 'when type is max_length' do
			let(:type) { :max_length }
			it { result.must_be_instance_of Veto::MaxLengthValidator }
		end

		context 'when type is min_length' do
			let(:type) { :min_length }
			it { result.must_be_instance_of Veto::MinLengthValidator }
		end

		context 'when type is not_null' do
			let(:type) { :not_null }
			it { result.must_be_instance_of Veto::NotNullValidator }
		end

		context 'when type is numeric' do
			let(:type) { :numeric }
			it { result.must_be_instance_of Veto::NumericValidator }
		end

		context 'when type is presence' do
			let(:type) { :presence }
			it { result.must_be_instance_of Veto::PresenceValidator }
		end

		context 'when type is type' do
			let(:type) { :type }
			it { result.must_be_instance_of Veto::TypeValidator }
		end

		context 'when type not recognized' do
			let(:type) { :blah }
			it 'raises error' do
				e = proc{ result }.must_raise(ArgumentError)
				e.message.must_equal 'Validator not found: ::Veto::BlahValidator'
			end
		end
	end
end