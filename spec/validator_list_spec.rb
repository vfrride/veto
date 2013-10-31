require 'spec_helper'
require 'veto/validator_list'

describe Veto::ValidatorList do
	let(:validator_list){ Veto::ValidatorList.new }

	describe 'add' do
		it 'pushes object into set' do
			validator = stub
			validator_list.send(:validator_list).must_equal []
			validator_list.add(validator)
			validator_list.send(:validator_list).must_equal [validator]
		end
	end
end