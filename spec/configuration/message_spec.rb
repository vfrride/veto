require 'spec_helper'

describe Veto::Configuration::Message do
  it 'gets message for check type' do
    msg = new_message
    msg.get(:exact_length, 23).must_equal('is not 23 characters')
  end

  it 'overrides message for check type' do
    msg = new_message
    msg.set(:exact_length, Proc.new{'custom message'})
    msg.get(:exact_length).must_equal('custom message')
  end

  context 'when type unknown' do
    it 'outputs default message' do
      msg = new_message
      msg.get(:does_not_exist).must_equal('is not valid')
    end
  end

  def new_message
    Veto::Configuration::Message.new
  end
end