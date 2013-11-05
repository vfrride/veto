require 'spec_helper'
require 'veto/builder'

describe Veto::Builder::ValidatesBuilder::ValidatorOptions do
	let(:type) { :persistence }
	let(:attribute) { :first_name }
	let(:original_options) { true }
	let(:additional_conditions) { {:if => :goodcond, :unless => :badcond} }
	let(:validator_options){ Veto::Builder::ValidatesBuilder::ValidatorOptions.new(type, attribute, original_options, additional_conditions) }

	describe '#original_options_hash' do
		let(:result){ validator_options.send(:original_options_hash) }

		context 'when original_options is TrueClass' do
			let(:original_options) { true }
			it { result.must_equal({}) }
		end

		context 'when original_options is Hash' do
			let(:original_options) { {:blah => 12} }
			it { result.must_equal(original_options) }
		end

		context 'when original_options is Array' do
			let(:original_options) { %w(cat dog pig) }
			it { result.must_equal({:in => original_options}) }
		end

		context 'when original_options is Range' do
			let(:original_options) { 1..10 }
			it { result.must_equal({:in => original_options}) }
		end

		context 'when original_options is anything else' do
			let(:original_options) { 1 }
			it { result.must_equal({:with => original_options}) }
		end
	end

	describe '#conditions' do
		let(:original_options) { {:with => 10, :if => :cond3} }
		let(:additional_conditions) { {:if => :goodcond, :unless => :badcond} }

		it 'returns conditions from original_options merged additional_conditions' do
			result = validator_options.send(:conditions)
			result.must_equal({:if=>[:goodcond, :cond3], :unless=>[:badcond]})
		end
	end

	describe '#options' do
		let(:original_options) { {:with => 10, :if => :cond3} }
		let(:additional_conditions) { {:if => :goodcond, :unless => :badcond} }

		it 'returns original_options merged with conditions' do
			result = validator_options.options
			result.must_equal({:with=>10, :if=>[:goodcond, :cond3], :unless=>[:badcond]})
		end
	end
end