require 'spec_helper'
require 'veto/builder'

describe Veto::Builder::ValidateBuilder do
	let(:method_names_and_conditions){ [:meth1, :meth2, {:if => :cond1}] }
	let(:additional_conditions) {{:if => :addcond1, :unless => :addcond2}}
	let(:builder) { Veto::Builder::ValidateBuilder.new(method_names_and_conditions, additional_conditions) }

	context 'when conditions not present' do
		let(:method_names_and_conditions){ [:meth1, :meth2] }

		describe '#method_names' do
			it {builder.method_names.must_equal [:meth1, :meth2]  }
		end

		describe '#conditions' do
			it { builder.conditions.must_equal({:if=>[:addcond1], :unless=>[:addcond2]}) }
		end
	end

	context 'when conditions are present' do
		let(:method_names_and_conditions){ [:meth1, :meth2, {:if => :cond1}] }

		describe '#method_names' do
			it {builder.method_names.must_equal [:meth1, :meth2]  }
		end

		describe '#conditions' do
			it { builder.conditions.must_equal({:if=>[:addcond1, :cond1], :unless=>[:addcond2]})}
		end
	end
end