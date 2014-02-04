require 'spec_helper'

describe Veto::MethodCheck do
  it 'delegates to method call on context' do
    check = Veto::MethodCheck.new(:name)
    entity = stub
    context = stub(:name => true)
    cco = stub(:entity => entity, :context => context)
    
    context.expects(:name).with(entity).once
    check.call(cco)
  end
end