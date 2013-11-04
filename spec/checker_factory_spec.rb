require 'spec_helper'
require 'veto/checker_factory'

describe Veto::CheckerFactory do
	let(:factory) { Veto::CheckerFactory }
	let(:type) { :format }

	describe '::new_checker' do
		let(:result) { factory.new_checker(type, stub, stub) }
	
		context 'when type is exact_length' do
			let(:type) { :exact_length }
			it { result.must_be_instance_of Veto::ExactLengthChecker }
		end

		context 'when type is format' do
			let(:type) { :format }
			it { result.must_be_instance_of Veto::FormatChecker }
		end

		context 'when type is inclusion' do
			let(:type) { :inclusion }
			it { result.must_be_instance_of Veto::InclusionChecker }
		end

		context 'when type is integer' do
			let(:type) { :integer }
			it { result.must_be_instance_of Veto::IntegerChecker }
		end

		context 'when type is length_range' do
			let(:type) { :length_range }
			it { result.must_be_instance_of Veto::LengthRangeChecker }
		end

		context 'when type is max_length' do
			let(:type) { :max_length }
			it { result.must_be_instance_of Veto::MaxLengthChecker }
		end

		context 'when type is min_length' do
			let(:type) { :min_length }
			it { result.must_be_instance_of Veto::MinLengthChecker }
		end

		context 'when type is not_null' do
			let(:type) { :not_null }
			it { result.must_be_instance_of Veto::NotNullChecker }
		end

		context 'when type is numeric' do
			let(:type) { :numeric }
			it { result.must_be_instance_of Veto::NumericChecker }
		end

		context 'when type is presence' do
			let(:type) { :presence }
			it { result.must_be_instance_of Veto::PresenceChecker }
		end

		context 'when type not recognized' do
			let(:type) { :blah }
			it 'raises error' do
				e = proc{ result }.must_raise(ArgumentError)
				e.message.must_equal 'Checker not found: ::Veto::BlahChecker'
			end
		end
	end
end