# require 'spec_helper'
# require 'veto/validators/inclusion_validator'

# describe Veto::InclusionValidator do
# 	let(:set) {[:cat, :dog, :rat]}
# 	let(:validator){ Veto::InclusionValidator }

# 	describe '#valid?' do
# 		context 'when set is array' do
# 			let(:set) {[:cat, :dog, :rat]}

# 			context 'when value is included' do
# 				it { validator.valid?(set, :cat).must_equal true }
# 			end

# 			context 'when value is not included' do
# 				it { validator.valid?(set, :beaver).must_equal false }
# 			end
# 		end

# 		context 'when set is range' do
# 			let(:set) {('a'..'g')}
			
# 			context 'when value is in range' do
# 				it { validator.valid?(set, 'f').must_equal true }
# 			end

# 			context 'when value is out of range' do
# 				it { validator.valid?(set, 'z').must_equal false }
# 			end
# 		end
# 	end
# end