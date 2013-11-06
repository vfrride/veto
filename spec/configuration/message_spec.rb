require 'spec_helper'
require 'veto/configuration'

describe Veto::Configuration::Message do
	let(:msg_proc){ Proc.new{'custom message'} }
	let(:msg){ Veto::Configuration::Message.new }

	describe '#set' do
		it 'sets options on type' do
			msg.send(:custom_messages).must_equal({})
			msg.set(:exact_format, msg_proc)
			msg.send(:custom_messages).must_equal({:exact_format => msg_proc})
		end
	end

	describe '#get' do
		context 'when custom_message is defined' do
			it 'returns custom message' do
				msg.set(:presence, msg_proc)
				msg.get(:presence).must_equal 'custom message'				
			end
		end

		context 'when custom_message is not defined' do
			it 'returns default message' do
				msg.get(:presence).must_equal 'is not present'				
			end
		end
	end
end