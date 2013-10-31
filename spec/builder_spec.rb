require 'spec_helper'
require 'veto/builder'
require 'veto/blocks/list_block'

describe Veto::Builder do
	let(:list){ Veto::ListBlock.new }
	let(:builder) { Veto::Builder.new(list) }

	describe "::new" do
		context 'when no block given' do
			it 'returns instance' do
				inst = Veto::Builder.new(stub)
				inst.must_be_instance_of Veto::Builder
			end
		end

		context 'when block given' do
			it 'evals block with new instance' do
				Veto::Builder.new(stub) do
					self.must_be_instance_of Veto::Builder
				end
			end
		end
	end

	describe '#with_options' do
		it 'adds conditional list block to context list' do
			list.send(:items).must_be_empty
			builder.with_options
			list.send(:items).wont_be_empty
			list.send(:items).first.must_be_instance_of Veto::ConditionalListBlock
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
 							  :exact_length => {:with => 5, :if => :good? },
 							  :not_null => true,
 							  :if => 'good',
 							  :unless => 'bad'

 			outer_list = list.send(:items).first
 			inner_list = outer_list.send(:items)
 			inner_list.length.must_equal 3
 		end
 	end
end