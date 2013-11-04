require 'spec_helper'
require 'veto/validator'

describe Veto do
	let(:person){ stub }
	let(:validator_class) { Class.new{ include Veto::Validator } }
	let(:validator) { validator_class.new(person) }

	describe 'with_options conditions' do
		context 'when conditions pass' do
			let(:validator_class) do
				klass = Class.new{
					include Veto::Validator

					with_options :if => true do
						validate :create_errors
					end

					def create_errors
						errors.add(:base, "error")
					end
				}
			end	

			it 'performs validations within block' do
				validator.valid?.must_equal false
				validator.errors.full_messages.must_equal ['base error']
			end
		end

		context 'when conditions fail' do
			let(:validator_class) do
				klass = Class.new{
					include Veto::Validator

					with_options :if => false do
						validate :create_errors
					end

					def create_errors
						errors.add(:base, "error")
					end
				}
			end	

			it 'does not perform validations within block' do
				validator.valid?
				validator.errors.must_be_empty
			end
		end


	end

	describe 'validates conditions' do
		let(:person){ stub(:title => nil, :name => 'John') }

		context 'when outer conditions pass' do
			context 'when inner conditions pass' do
				let(:validator_class) do
					klass = Class.new{
						include Veto::Validator

						validates :title, :not_null => {:with => true, :if => true}, :exact_length => {:with => 4, :if => true}, :if => true
					}
				end	

				it 'performs validation' do
					validator.valid?.must_equal false
					validator.errors.full_messages.must_equal ["title is not present", "title is not 4 characters"]
				end				
			end

			context 'when inner conditions fail' do
				let(:validator_class) do
					klass = Class.new{
						include Veto::Validator

						validates :title, :not_null => {:with => true, :if => false}, :exact_length => {:with => 4, :if => true}, :if => true
					}
				end	

				it 'skips individual validator' do
					validator.valid?.must_equal false
					validator.errors.full_messages.must_equal ["title is not 4 characters"]
				end
			end
		end

		context 'when outer conditions fail' do
			let(:validator_class) do
				klass = Class.new{
					include Veto::Validator

					validates :title, :not_null => {:with => true, :if => true}, :exact_length => {:with => 4, :if => true}, :if => false
				}
			end	

			it 'skips validates block' do
				validator.valid?.must_equal true
			end
		end
	end

	context 'when using custom validator' do
		let(:person){ stub(:email_address => 'blah') }
		let(:validator_class) do
			klass = Class.new{
				include Veto::Validator

				class EmailValidator < ::Veto::AttributeValidator
					def validate entity, attribute, value, errors, options={}
						unless value.to_s =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
							errors.add(attribute, "is not a valid email address")
						end
					end
				end

				validates :email_address, :email => true
			}
		end	

		it 'uses custom validator' do
			validator.valid?.must_equal false
			validator.errors.full_messages.must_equal ["email_address is not a valid email address"]
		end
	end
end