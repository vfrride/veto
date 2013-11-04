require 'spec_helper'
require 'veto/validates_options'

describe Veto::Validates::ValidatesOptions do
	let(:attribute){ :name }
	let(:options){ {:integer => true, :if => :is_good?, :unless => :is_bad?} }
	let(:parser){ Veto::Validates::ValidatesOptions.new(attribute, options) }
	
	describe '#conditions' do
		it 'selects and returns conditions from options hash' do
			parser.conditions.must_equal({:if => :is_good?, :unless => :is_bad?})
		end
	end

	describe '#validator_options_hash' do
		it 'selects and returns validator_options_hash from options hash' do
			parser.send(:validator_options_hash).must_equal({:integer => true})
		end
	end

	describe '#validator_options' do
		it 'returns array of validator options objects' do
			vopts = parser.send(:validator_options)
			vopts.length.must_equal 1
			vopts[0].must_be_instance_of Veto::Validates::ValidatesOptions::CheckerOptions
		end
	end

	describe '#each_checker_options' do
		it 'yields list of validator options' do
			parser.each_checker_options do |vop|
				vop.must_be_instance_of Veto::Validates::ValidatesOptions::CheckerOptions
			end
		end
	end
end