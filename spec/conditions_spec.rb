require 'spec_helper'
require 'veto/conditions'

describe Veto::Conditions do
	let(:entity) {stub(:is_dead => false)}
	let(:context) {stub(:is_valid? => true)}
	let(:conditions) { {:if => [true, :is_valid?], :unless => Proc.new{|e| e.is_dead}} }
	let(:result) { Veto::Conditions.truthy?(context, entity, conditions) }

	describe '::truthy?' do
		context 'when conditions pass' do
			it { result.must_equal true }
		end

		context 'when conditions fail' do
			let(:context) {stub(:is_valid? => false)}
			it { result.must_equal false }
		end
	end
end