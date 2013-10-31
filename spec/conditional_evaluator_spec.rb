require 'spec_helper'
require 'veto/conditional_evaluator'

describe Veto::ConditionalEvaluator do
	let(:conditions){}
	let(:entity){Object.new}
	let(:context){Object.new}
	let(:evaluator) { Veto::ConditionalEvaluator.new(conditions) }
	
	describe '::truthy?' do
		let(:condition){}
		let(:result) { Veto::ConditionalEvaluator.truthy?(condition, context, entity) }

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

		context 'when condition is string' do
			let(:entity) { stub(:is_alive => true) }
			let(:condition) { 'is_alive' }
			it { result.must_equal true }
		end

		context 'when condition is empty string' do
			let(:condition) { '' }
			it { result.must_equal false }
		end

		context 'when condition is empty hash' do
			let(:condition) { {} }
			it { result.must_equal true }
		end

		context 'when condition is method_name symbol' do
			let(:context) { stub(:active? => true) }
			let(:condition) { :active? }
			it { result.must_equal true }
		end

		context 'when condition is proc' do
			let(:entity) { stub(:is_alive => true) }
			let(:condition) { Proc.new{|e| e.is_alive } }
			it { result.must_equal true }
		end
	end

	describe '::truthy_conditionals?' do
		let(:conditionals){}
		let(:result) { Veto::ConditionalEvaluator.truthy_conditionals?(conditionals, context, entity) }

		context 'when no conditionals are assigned' do
			let(:conditionals){{}}
			it { result.must_equal true }	
		end

		context 'when if conditionals return true' do
			context 'when unless conditionals return false' do
				let(:conditionals){{:if => [true, true], :unless => [false, false]}}
				it { result.must_equal true }
			end

			context 'when one unless conditionals returns true' do
				let(:conditionals){{:if => [true, true], :unless => [true, false]}}
				it { result.must_equal false }
			end
		end

		context 'when one if conditional returns false' do
			let(:conditionals){{:if => [false, true], :unless => [false, false]}}
			it { result.must_equal false }
		end
	end

end