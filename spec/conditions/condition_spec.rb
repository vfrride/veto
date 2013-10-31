require 'spec_helper'
require 'veto/conditions/condition'

describe Veto::Condition do
	let(:entity) {stub}
	let(:context) {stub}
	let(:condition) { false }
	let(:result) { Veto::Condition.truthy?(context, entity, condition) }

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
end