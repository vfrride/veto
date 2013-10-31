require 'spec_helper'
require 'veto/blocks/list_block'

describe Veto::ListBlock do
	let(:list) { Veto::ListBlock.new }

	describe '#add' do
		it 'adds item to block' do
			item = Object.new
			list.send(:items).size.must_equal 0
			list.add item
			list.send(:items).size.must_equal 1
		end
	end

	describe '#execute' do
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
end