require 'spec_helper'
require 'veto/builder'

describe Veto::Builder do
	let(:context) {stub}
	let(:context_conditions){ {:if => :is_good?} }
	let(:builder) { Veto::Builder.new(context, context_conditions) }

	describe '#with_options' do
		it 'calls with_options method on context' do
			context.expects(:with_options)
			builder.with_options(:if => :is_tasty?, :unless => :rotten?)
		end

		it 'combines context_conditions with conditions' do
			context.expects(:with_options).with({:if => [:is_good?, :is_tasty?], :unless => [:rotten?]})
			builder.with_options(:if => :is_tasty?, :unless => :rotten?)
		end
	end

	describe '#validates' do
		it 'calls validates method on context' do
			context.expects(:validates)
			builder.validates(:first_name, :presence => true, :if => 'high5')
		end

		it 'combines context_conditions with options' do
			context.expects(:validates).with(:first_name, {:presence => true, :if => [:is_good?, 'high5'], :unless => []})
			builder.validates(:first_name, :presence => true, :if => 'high5')
		end	
	end

	describe '#validate' do
		it 'calls validate method on context' do
			context.expects(:validate)
			builder.validate(:meth1, :meth2)
		end

		it 'combines context_conditions with options' do
			context.expects(:validate).with(:meth1, :meth2, {:if => [:is_good?], :unless => []})
			builder.validate(:meth1, :meth2)
		end	
	end
end