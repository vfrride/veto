require 'spec_helper'
require 'veto/conditions/proc_condition'

describe Veto::ProcCondition do
	let(:context) {stub}
	let(:entity) {stub}
	let(:condition) { false }
	let(:result) { Veto::ProcCondition.truthy?(context, entity, condition) }

	describe '::truthy?' do
		context 'when condition is proc' do
			let(:entity) { stub(:is_alive => true) }
			let(:condition) { Proc.new{|e| e.is_alive } }
			it { result.must_equal true }
		end
	end

	describe '::match?' do
		context 'when condition is proc' do
			it { Veto::ProcCondition.match?(Proc.new{|e| e.is_alive }).must_equal true }
		end

		context 'when condition not string' do
			it { Veto::ProcCondition.match?(:not_proc).must_equal false }
		end
	end
end