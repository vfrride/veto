require 'spec_helper'
require 'veto/checkers/exact_length_checker'
require 'veto/errors'

describe Veto::ExactLengthChecker do
	let(:errors){ Veto::Errors.new }
	let(:entity) { Object.new }
	let(:attribute) { :title }
	let(:value) { 'blahblah' }
	let(:options) {{:with => 10}}
	let(:validator){ Veto::ExactLengthChecker.new(stub, stub) }
	let(:result){ validator.validate(entity, attribute, value, errors, options) }

	describe '#validate' do
		before { result }

		context 'when value exact length' do
			let(:value) { 'abcdefghij' }
			it { errors[:title].must_be_nil }
		end

		context 'when value is too short' do
			let(:value) { 'short' }
			it { errors[:title].must_equal ["is not 10 characters"] }
		end

		context 'when value is too long' do
			let(:value) { 'this title is wayyyy to long' }
			it { errors[:title].must_equal ["is not 10 characters"] }
		end

		context 'when value is nil' do
			let(:value) { nil }
			it { errors[:title].must_equal ["is not 10 characters"] }
		end
	end
end