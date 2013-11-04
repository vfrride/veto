require 'spec_helper'
require 'veto/checkers/length_range_checker'
require 'veto/errors'

describe Veto::LengthRangeChecker do
	let(:errors){ Veto::Errors.new }
	let(:entity) { Object.new }
	let(:attribute) { :title }
	let(:value) { 'blahblah' }
	let(:options) {{:in => (1..10)}}
	let(:validator){ Veto::LengthRangeChecker.new(attribute, options) }
	let(:result){ validator.validate(entity, attribute, value, errors, options) }

	describe '#validate' do
		before { result }

		context 'when range is array' do
			let(:options) {{:in => [5, 8, 15]}}

			context 'when value length is in array' do
				let(:value) { 'abcde' }
				it { errors[:title].must_be_nil }
			end

			context 'when value length is not in array' do
				let(:value) { 'abc' }
				it { errors[:title].must_equal ["is too short or too long"] }
			end

			context 'when value length is nil' do
				let(:value) { nil }
				it { errors[:title].must_equal ["is too short or too long"] }
			end
		end

		context 'when range is range' do
			let(:options) {{:in => (5..10)}}

			context 'when value length is in range' do
				let(:value) { 'abcdef' }
				it { errors[:title].must_be_nil }
			end

			context 'when value length is not in range' do
				let(:value) { 'abc' }
				it { errors[:title].must_equal ["is too short or too long"] }
			end

			context 'when value length is nil' do
				let(:value) { nil }
				it { errors[:title].must_equal ["is too short or too long"] }
			end	
		end
	end
end