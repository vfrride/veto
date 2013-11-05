require 'spec_helper'
require 'veto/builder'

describe Veto::Builder::ValidatesBuilder do
	let(:attribute){ :first_name }
	let(:original_options) { {:presence => true, :exact_length => 10, :if => :cond1} }
	let(:additional_options) {{:unless => :cond2}}
	let(:validates_options) { Veto::Builder::ValidatesBuilder.new(attribute, original_options, additional_options) }

	describe '#new_validator_options' do
		it 'returns new validator options instance' do
			Veto::Builder::ValidatesBuilder::ValidatorOptions.expects(:new).with(:persistence, :first_name, true, {:if => [:cond1], :unless => [:cond2]})
			validates_options.send(:new_validator_options, :persistence, true)
		end
	end

	describe '#validator_options' do
		it 'returns list of validator_options' do
			validates_options.send(:validator_options).each do |vop|
				vop.must_be_instance_of Veto::Builder::ValidatesBuilder::ValidatorOptions
			end
		end
	end

	describe '#conditions' do
		it 'returns conditions hash' do
			validates_options.send(:conditions).must_equal({:if=>[:cond1], :unless=>[:cond2]})
		end
	end

	describe '#options' do
		it 'returns options hash' do
			validates_options.send(:options).must_equal({:presence => true, :exact_length => 10})
		end
	end
end