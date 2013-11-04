require 'spec_helper'
require 'veto/validators/integer_validator'
require 'veto/errors'

describe Veto::IntegerValidator do
	let(:errors){ Veto::Errors.new }
	let(:entity) { Object.new }
	let(:attribute) { :title }
	let(:value) { 'blahblah' }
	let(:options) {{:with => {}}}
	let(:validator){ Veto::IntegerValidator.new(stub, stub) }
	let(:result){ validator.validate(entity, attribute, value, errors, options) }

	describe '#validate' do
		before { result }

		context 'when value is integer' do
			let(:value) { 123 }
			it { errors[:title].must_be_nil }
		end

		context 'when value is float' do
			let(:value) { 123.4 }
			it { errors[:title].must_equal ["is not a number"]}
		end

		context 'when value is string' do
			let(:value) { 'abc' }
			it { errors[:title].must_equal ["is not a number"]}
		end

		context 'when value is nil' do
			let(:value) { nil }
			it { errors[:title].must_equal ["is not a number"]}
		end

		context 'when value is everything else' do
			let(:value) { ['array'] }
			it { errors[:title].must_equal ["is not a number"]}
		end
	end
end