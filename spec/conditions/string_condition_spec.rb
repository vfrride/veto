require 'spec_helper'
require 'veto/conditions/string_condition'

describe Veto::StringCondition do
	let(:context) {stub}
	let(:entity) {stub}
	let(:condition) { false }
	let(:result) { Veto::StringCondition.truthy?(context, entity, condition) }

	describe '::truthy?' do
		context 'when condition is string' do
			let(:entity) { stub(:is_alive => true) }
			let(:condition) { 'is_alive' }
			it { result.must_equal true }
		end

		context 'when condition is empty string' do
			let(:condition) { '' }
			it { result.must_equal false }
		end
	end

	describe '::match?' do
		context 'when condition is string' do
			it { Veto::StringCondition.match?('string').must_equal true }
		end

		context 'when condition not string' do
			it { Veto::StringCondition.match?(:not_String).must_equal false }
		end
	end
end