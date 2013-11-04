require 'spec_helper'
require 'veto/checkers/format_checker'
require 'veto/errors'

describe Veto::FormatChecker do
	let(:errors){ Veto::Errors.new }
	let(:entity) { Object.new }
	let(:attribute) { :title }
	let(:value) { 'blahblah' }
	let(:options) {{:with => /^\d+$/}}
	let(:validator){ Veto::FormatChecker.new(stub, stub) }
	let(:result){ validator.validate(entity, attribute, value, errors, options) }

	describe '#validate' do
		before { result }

		context 'when value matches pattern' do
			let(:value) { 123 }
			it { errors[:title].must_be_nil }
		end

		context 'when value does not match' do
			let(:value) { 'abc' }
			it { errors[:title].must_equal ["is not valid"] }
		end

		context 'when value is nil' do
			let(:value) { nil }
			it { errors[:title].must_equal ["is not valid"] }
		end
	end
end