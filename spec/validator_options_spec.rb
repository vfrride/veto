require 'spec_helper'
require 'veto/validates_options'

describe Veto::Validates::ValidatesOptions::CheckerOptions do
	let(:type){ :integer }
	let(:attribute) {:first_name}
	let(:options){ {} }
	let(:config){ Veto::Validates::ValidatesOptions::CheckerOptions.new(type, attribute, options) }
	
	describe 'options' do
		context 'when options true' do
			let(:options){ true }
			it { config.options.must_equal({}) }
		end

		context 'when options is hash' do
			let(:options){ {:message => 'cannot be blank', :if => :broken?} }
			it { config.options.must_equal options }
		end

		context 'when options is array' do
			let(:options){ %w(cat dog horse) }
			it { config.options.must_equal({:in => options}) }
		end

		context 'when options is range' do
			let(:options){ 1..10 }
			it { config.options.must_equal({:in => options}) }
		end

		context 'when options is anything else' do
			let(:options){ 10 }
			it { config.options.must_equal({:with => options}) }
		end
	end

	describe '#conditions' do
		context 'when options is hash' do
			let(:options){ {:message => 'cannot be blank', :if => :broken?} }
			it { config.conditions.must_equal({:if => :broken?}) }
		end

		context 'when options is not hash' do
			let(:options){ %w(cat dog horse) }
			it { config.conditions.must_equal({}) }
		end
	end
end