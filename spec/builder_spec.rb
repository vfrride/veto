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
		it 'adds condition list block to context list' do
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

		it 'build list by chaining builders' do
			builder.with_options do
				with_options do
					with_options do
					end
				end
			end
			list_items = list.send(:items)
			list_items.size.must_equal 1

			list2_items = list_items[0].send(:items)
			list2_items.size.must_equal 1

			list3_items = list2_items[0].send(:items)
			list3_items.size.must_equal 1
		end
 	end

 	describe '#validates' do
 		it 'adds validators to validation list' do
 			builder.validates :first_name, :integer => true, 
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