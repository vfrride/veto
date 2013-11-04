require 'spec_helper'
require 'veto/validators/min_length_validator'
require 'veto/errors'

describe Veto::MinLengthValidator do
	let(:errors){ Veto::Errors.new }
	let(:entity) { Object.new }
	let(:attribute) { :title }
	let(:value) { 'blahblah' }
	let(:options) {{:with => 5}}
	let(:validator){ Veto::MinLengthValidator.new(stub, stub) }
	let(:result){ validator.validate(entity, attribute, value, errors, options) }

	describe '#validate' do
		before { result }

		context 'when value length is greater than min' do
			let(:value) { 'abcdefg' }
			it { errors[:title].must_be_nil }
		end

		context 'when value is too short' do
			let(:value) { 'abcd' }
			it { errors[:title].must_equal ["is shorter than 5 characters"] }
		end

		context 'when value is nil' do
			let(:value) { nil }
			it { errors[:title].must_equal ["is shorter than 5 characters"] }
		end
	end
end