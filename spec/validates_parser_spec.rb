require 'spec_helper'
require 'veto/validates_options'

describe Veto::ValidatesOptions do
	let(:attribute){ :name }
	let(:options){ {:presence => true, :if => :is_good?, :unless => :is_bad?} }
	let(:parser){ Veto::ValidatesOptions.new(attribute, options) }
	
	describe '#conditions' do
		it 'selects and returns conditions from options hash' do
			parser.conditions.must_equal({:if => :is_good?, :unless => :is_bad?})
		end
	end

	describe '#validator_options_hash' do
		it 'selects and returns validator_options_hash from options hash' do
			parser.send(:validator_options_hash).must_equal({:presence => true})
		end
	end

	describe '#validator_options' do
		it 'returns array of validator options objects' do
			vopts = parser.send(:validator_options)
			vopts.length.must_equal 1
			vopts[0].must_be_instance_of Veto::ValidatesOptions::ValidatorOptions
		end
	end

	describe '#each_validator_options' do
		it 'yields list of validator options' do
			parser.each_validator_options do |vop|
				vop.must_be_instance_of Veto::ValidatesOptions::ValidatorOptions
			end
		end
	end
end