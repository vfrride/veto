# require 'spec_helper'
# require 'veto/validators/integer_validator'

# describe Veto::IntegerValidator do
# 	let(:validator){ Veto::IntegerValidator }

# 	describe '#valid?' do
# 		context 'when value is integer' do
# 			it { validator.valid?(123).must_equal true }
# 		end

# 		context 'when value is string integer' do
# 			it { validator.valid?('123').must_equal true }
# 		end

# 		context 'when value is string' do
# 			it { validator.valid?('abc').must_equal false }
# 		end

# 		context 'when value is float' do
# 			it { validator.valid?(2.123).must_equal false }
# 		end

# 		context 'when value is nil' do
# 			it { validator.valid?(nil).must_equal false }
# 		end
# 	end
# end