require 'spec_helper'
require 'veto'

describe Veto do
	describe '::model' do
		let(:klass){ Class.new{ include Veto.model('validator class') } }

		it 'includes model module to class' do
			klass.included_modules.must_include Veto::Model
		end

		it 'sets model validator' do
			klass.validator.must_equal 'validator class'
		end
	end

	describe '::validator' do
		let(:klass){ Class.new{ include Veto.validator } }

		it 'includes validator module to class' do
			klass.included_modules.must_include Veto::Validator
		end
	end
end