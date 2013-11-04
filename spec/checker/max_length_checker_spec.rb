require 'spec_helper'
require 'veto/checkers/max_length_checker'
require 'veto/errors'

describe Veto::MaxLengthChecker do
	let(:errors){ Veto::Errors.new }
	let(:entity) { Object.new }
	let(:attribute) { :title }
	let(:value) { 'blahblah' }
	let(:options) {{:with => 10}}
	let(:validator){ Veto::MaxLengthChecker.new(stub, stub) }
	let(:result){ validator.validate(entity, attribute, value, errors, options) }

	describe '#validate' do
		before { result }

		context 'when value length is less than max' do
			let(:value) { 'abc' }
			it { errors[:title].must_be_nil }
		end

		context 'when value is too long' do
			let(:value) { 'abcdefghijklmnop' }
			it { errors[:title].must_equal ["is longer than 10 characters"] }
		end

		context 'when value is nil' do
			let(:value) { nil }
			it { errors[:title].must_equal ["is longer than 10 characters"] }
		end
	end
end