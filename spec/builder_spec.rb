require 'spec_helper'
require 'veto/builder'
require 'veto/validator_list'

describe Veto::Builder do
	let(:validator_list){ Veto::ValidatorList.new }
	let(:builder) { Veto::Builder.new(validator_list) }

	describe "::new" do
		context 'when no block given' do
			it 'returns instance' do
				inst = Veto::Builder.new(stub)
				inst.must_be_instance_of Veto::Builder
			end
		end
	end

	describe '#with_options' do
		it 'adds conditional validator to validator_list' do
			validator_list.send(:validator_list).must_be_empty
			builder.with_options
			validator_list.send(:validator_list).wont_be_empty
		end

		it 'yields builder to block' do
			builder.with_options do
				self.must_be_instance_of Veto::Builder
			end
		end
 	end

 	describe '#validates' do
 		it 'adds validators to validation list' do
 			builder.validates :first_name, :presence => true, 
 							  :exact_length => {:with => 5, :if => :stuff_is_good? },
 							  :not_null => true

 			list = validator_list.send(:validator_list)
 			list.length.must_equal 3
 		end
 	end
end