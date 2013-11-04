require 'spec_helper'
require 'veto/blocks/conditional_list_block'

describe Veto::ConditionalListBlock do
	let(:condition_proc) { Proc.new{true} }
	let(:list) { Veto::ConditionalListBlock.new(condition_proc) }

	describe '#add' do
		it 'adds item to block' do
			item = Object.new
			list.send(:items).size.must_equal 0
			list.add item
			list.send(:items).size.must_equal 1
		end
	end

	describe '#execute' do
		context 'when condition is truthy' do
			let(:condition_proc) { Proc.new{true} }

			it 'delegates method call to each item in list' do
				item1 = Object.new
				item2 = Object.new
				list.add item1
				list.add item2

				args = 'some args'
				item1.expects(:execute).with(args)
				item2.expects(:execute).with(args)
				list.execute(args)
			end
		end

		context 'when condition is falsey' do
			let(:condition_proc) { Proc.new{false } }

			it 'delegates method call to each item in list' do
				item1 = Object.new
				item2 = Object.new
				list.add item1
				list.add item2

				args = 'some args'
				list.execute(args)
			end
		end
	end
end