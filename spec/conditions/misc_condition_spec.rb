require 'spec_helper'
require 'veto/conditions/misc_condition'

describe Veto::MiscCondition do
	let(:context) {stub}
	let(:entity) {stub}
	let(:condition) { false }
	let(:result) { Veto::MiscCondition.truthy?(context, entity, condition) }

	describe '::truthy?' do
		context 'when condition is true' do
			let(:condition) { true }
			it { result.must_equal true }
		end

		context 'when condition is false' do
			let(:condition) { false }
			it { result.must_equal false }
		end

		context 'when condition is nil' do
			let(:condition) { nil }
			it { result.must_equal false }
		end

		context 'when condition is 0' do
			let(:condition) { 0 }
			it { result.must_equal true }
		end
	end

	describe '::match?' do
		it { Veto::MiscCondition.match?('anything').must_equal true }
	end
end