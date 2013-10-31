require 'spec_helper'
require 'veto/conditional_validator_list'

describe Veto::ConditionalValidatorList do
	let(:conditions) {{}}
	let(:list){ Veto::ConditionalValidatorList.new(conditions) }

	describe '#add' do
		it 'adds item to internal validator_list' do
			item = stub
			list.send(:validator_list).send(:validator_list).must_equal []
			list.add item
			list.send(:validator_list).send(:validator_list).must_equal [item]
		end
	end

	describe '#validate' do
		context 'when conditions pass' do
			it 'does calls validate on internal list' do
				validator_list = stub
				list.expects(:conditions_truthy?).returns(true)
				list.expects(:validator_list).returns(validator_list)
				validator_list.expects(:validate)
				list.validate(stub, stub, stub)
			end
		end 
		
		context 'when conditions fail' do
			it 'does not call validate on interal list' do
				validator_list = stub
				list.expects(:conditions_truthy?).returns(false)
				list.validate(stub, stub, stub)
			end
		end
	end
end