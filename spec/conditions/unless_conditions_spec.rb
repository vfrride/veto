require 'spec_helper'
require 'veto/conditions/unless_conditions'

describe Veto::UnlessConditions do
	let(:entity) {stub}
	let(:context) {stub}
	let(:condition) { false }
	let(:result) { Veto::UnlessConditions.truthy?(context, entity, condition) }

	describe '::truthy?' do
		context 'when condition is nil' do
			let(:condition) { nil }
			it { result.must_equal false }
		end
		
		context 'when condition is array' do
			context 'when all conditions are false' do
				let(:entity) { stub(:is_alive => false) }
				let(:context) { stub(:active? => false) }
				let(:condition) { [false, :active?, Proc.new{|e| e.is_alive}] }
				it { result.must_equal false }
			end

			context 'when one condition is true' do
				let(:entity) { stub(:is_alive => false) }
				let(:context) { stub(:active? => true) }
				let(:condition) { [false, :active?, Proc.new{|e| e.is_alive}] }
				it { result.must_equal true }
			end
		end
	end
end