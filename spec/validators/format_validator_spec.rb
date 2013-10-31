# require 'spec_helper'
# require 'veto/validators/format_validator'

# describe Veto::FormatValidator do
# 	let(:pattern){ /^\d+$/ }
# 	let(:validator){ Veto::FormatValidator }

# 	describe '#valid?' do
# 		context 'when value matches pattern' do
# 			it { validator.valid?(pattern, '123').must_equal true }
# 		end

# 		context 'when value does not match pattern' do
# 			it { validator.valid?(pattern, 'abc').must_equal false }
# 		end

# 		context 'when value is nil' do
# 			it { validator.valid?(pattern, nil).must_equal false }
# 		end
# 	end
# end