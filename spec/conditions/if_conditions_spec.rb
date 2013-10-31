require 'spec_helper'
require 'veto/conditions/if_conditions'

describe Veto::IfConditions do
	let(:entity) {stub}
	let(:context) {stub}
	let(:condition) { false }
	let(:result) { Veto::IfConditions.truthy?(context, entity, condition) }

	describe '::truthy?' do
		context 'when condition is nil' do
			let(:condition) { nil }
			it { result.must_equal false }
		end
		
		context 'when condition is array' do
			context 'when all conditions are true' do
				let(:entity) { stub(:is_alive => true) }
				let(:context) { stub(:active? => true) }
				let(:condition) { [true, :active?, Proc.new{|e| e.is_alive}] }
				it { result.must_equal true }
			end

			context 'when one condition is false' do
				let(:entity) { stub(:is_alive => false) }
				let(:context) { stub(:active? => true) }
				let(:condition) { [true, :active?, Proc.new{|e| e.is_alive}] }
				it { result.must_equal false }
			end
		end
	end
end