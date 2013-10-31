require 'spec_helper'
require 'veto/conditions/symbol_condition'

describe Veto::SymbolCondition do
	let(:context) {stub}
	let(:entity) {stub}
	let(:condition) { false }
	let(:result) { Veto::SymbolCondition.truthy?(context, entity, condition) }

	describe '::truthy?' do
		context 'when condition is method_name symbol' do
			let(:context) { stub(:active? => true) }
			let(:condition) { :active? }
			it { result.must_equal true }
		end
	end

	describe '::match?' do
		context 'when condition is string' do
			it { Veto::SymbolCondition.match?(:not_String).must_equal true }
		end

		context 'when condition not string' do
			it { Veto::SymbolCondition.match?('string').must_equal false }
		end
	end
end