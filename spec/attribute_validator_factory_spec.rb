require 'spec_helper'
require 'veto/attribute_validator_factory'
require 'veto'

describe Veto::AttributeValidatorFactory do
	let(:factory) { Veto::AttributeValidatorFactory }
	let(:type) { :format }

	describe '::new_validator' do
		let(:attribute){ :first_name }
		let(:options) { {} }
		let(:result) { factory.new_validator(type, attribute, options) }
	
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

		context 'when type not recognized' do
			let(:type) { :blah }
			it 'raises error' do
				e = proc{ result }.must_raise(ArgumentError)
				e.message.must_equal 'Validator not found: ::Veto::BlahValidator'
			end
		end
	end
end