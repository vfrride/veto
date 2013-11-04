require 'spec_helper'
require 'veto/checkers/not_null_checker'
require 'veto/errors'

describe Veto::NotNullChecker do
	let(:errors){ Veto::Errors.new }
	let(:entity) { Object.new }
	let(:attribute) { :title }
	let(:value) { 'blahblah' }
	let(:options) {{:with => {}}}
	let(:validator){ Veto::NotNullChecker.new(stub, stub) }
	let(:result){ validator.validate(entity, attribute, value, errors, options) }

	describe '#validate' do
		before { result }

		context 'when value is not null' do
			let(:value) { 123 }
			it { errors[:title].must_be_nil }
		end

		context 'when value is nil' do
			let(:value) { nil }
			it { errors[:title].must_equal ["is not present"]}
		end
	end
end