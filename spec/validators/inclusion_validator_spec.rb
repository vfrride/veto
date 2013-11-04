require 'spec_helper'
require 'veto/validators/inclusion_validator'
require 'veto/errors'

describe Veto::InclusionValidator do
	let(:errors){ Veto::Errors.new }
	let(:entity) { Object.new }
	let(:attribute) { :title }
	let(:value) { 'blahblah' }
	let(:options) {{:in => %w(cat dog bird rabbit)}}
	let(:validator){ Veto::InclusionValidator.new(stub, stub) }
	let(:result){ validator.validate(entity, attribute, value, errors, options) }

	describe '#validate' do
		before { result }

		context 'when set is array' do
			let(:options) {{:in => %w(cat dog bird rabbit)}}

			context 'when value is in set' do
				let(:value) { 'cat' }
				it { errors[:title].must_be_nil }
			end

			context 'when value is not in set' do
				let(:value) { 'goat' }
				it { errors[:title].must_equal ["is not in set: [\"cat\", \"dog\", \"bird\", \"rabbit\"]"]}
			end
		end

		context 'when set is range' do
			let(:options) {{:in => (10..20)}}

			context 'when value is in set' do
				let(:value) { 11 }
				it { errors[:title].must_be_nil }
			end

			context 'when value is not in set' do
				let(:value) { 5 }
				it { errors[:title].must_equal ["is not in set: 10..20"] }
			end
		end
	end
end