# require 'spec_helper'
# require 'veto/builder'

# describe Veto::Builder do
# 	let(:context) {stub}
# 	let(:context_conditions){ {:if => :is_good?} }
# 	let(:builder) { Veto::Builder.new(context, context_conditions) }

# 	describe '#with_options' do
# 		it 'returns new builder instance' do
# 			result = builder.with_options(:if => :is_tasty?, :unless => :rotten?)
# 			result.must_be_instance_of Veto::Builder
# 		end

# 		it 'passes conditions to instance as new conditions context' do
# 			result = builder.with_options(:if => :is_tasty?, :unless => :rotten?)
# 			result.conditions_context.must_equal({:if=>[:is_good?, :is_tasty?], :unless=>[:rotten?]})
# 		end
# 	end

# 	describe '#validates' do
# 		it 'passes list of validators to validates_with' do
# 			validators = stub
# 			Veto::Builder::ValidatesBuilder.expects(:validators).returns(validators)
# 			builder.expects(:validate_with).with(validators)
# 			builder.validates(:first_name, :presence => true, :if => 'high5')
# 		end
# 	end

# 	describe '#validate' do
# 		it 'passes list of validators to validates_with' do
# 			validators = stub
# 			builder.expects(:validate_with)
# 			Veto::Builder::ValidateBuilder.expects(:validators).returns(validators)
# 			builder.validate(:meth1, :meth2, :if => :cond1)
# 		end
# 	end
# end