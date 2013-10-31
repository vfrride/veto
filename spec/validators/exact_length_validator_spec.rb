# require 'spec_helper'
# require 'veto/validators/exact_length_validator'

# describe Veto::ExactLengthValidator do
# 	let(:validator){ Veto::ExactLengthValidator }

# 	describe '#valid?' do
# 		context 'when value is exact length' do
# 			it { validator.valid?(5, 'exact').must_equal true }
# 		end

# 		context 'when value is too long' do
# 			it { validator.valid?(5, 'toolongstring').must_equal false }
# 		end

# 		context 'when value is too short' do
# 			it { validator.valid?(5, 'tiny').must_equal false }
# 		end

# 		context 'when value is nil' do
# 			it { validator.valid?(5, nil).must_equal false }
# 		end
# 	end
# end