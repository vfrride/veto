require 'spec_helper'
require 'veto/conditions'

describe Veto::Conditions do
	let(:params){{:if => :condition1, :unless => :condition2}}
	let(:conditions){ Veto::Conditions.new(params) }

	describe '::merge' do
		it 'extracts and merges condition values' do
			cond1 = {:if => [:is_good?, :is_tasty?]}
			cond2 = {:if => "shaking", :unless => :is_bad?, :anotherkey => 'value'}
			result = Veto::Conditions.merge(cond1, cond2)
			result.must_equal({:if => [:is_good?, :is_tasty?, "shaking"], :unless => [:is_bad?]})
		end
	end
end