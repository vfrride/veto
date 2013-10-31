# require 'spec_helper'
# require 'veto/validators/length_range_validator'

# describe Veto::LengthRangeValidator do
# 	let(:range) {(5..10)}
# 	let(:validator){ Veto::LengthRangeValidator }

# 	describe '#valid?' do
# 		context 'when range is range' do
# 			let(:range) {(5..10)}
			
# 			context 'when value length is in range' do
# 				it { validator.valid?(range, 'abcdefg').must_equal true }
# 			end

# 			context 'when value length is out of range' do
# 				it { validator.valid?(range, 'abc').must_equal false }
# 			end
# 		end

# 		context 'when range is array' do
# 			let(:range) {[3, 17, 72]}

# 			context 'when value length is included' do
# 				it { validator.valid?(range, 'yup').must_equal true }
# 			end

# 			context 'when value length is not included' do
# 				it { validator.valid?(range, 'negative').must_equal false }
# 			end
# 		end
# 	end
# end