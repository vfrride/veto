require 'spec_helper'
require 'veto/errors'
require 'veto'

describe Veto::Errors do
	let(:errors){ Veto::Errors.new }
	describe '#add' do
		context 'when message is string' do
			it 'adds message to errors' do
				errors.add(:name, 'is too long')
				errors[:name].must_equal ['is too long']
			end
		end

		context 'when message contains message dictionary key' do
			it 'adds dictionary message to errors' do
				errors.add(:name, :presence)
				errors[:name].must_equal ["is not present"]
			end
		end
	end
end