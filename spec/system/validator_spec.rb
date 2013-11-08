require 'spec_helper'
require 'veto'

describe Veto do
	let(:entity){ stub }
	let(:validator_class) { Class.new{ include Veto.validator }}
	let(:validator) { validator_class.new(entity) }

	describe 'built-in validations' do
		let(:value) { 'abc123' }
		let(:entity) {stub(:name => value)}
		let(:errors) { validator.valid?; validator.errors.on(:name) }
		let(:validator_type){ :presence }
		let(:options) { true }
		let(:validator_class) do
			klass = Class.new{ include Veto.validator }
			klass.validates :name, options
			klass
		end	

		describe 'exact_length' do
			let(:options) {{:exact_length => 10}}

			context 'when value exact length' do
				let(:value) { 'abcdefghij' }
				it { errors.must_be_nil }
			end

			context 'when value is too short' do
				let(:value) { 'short' }
				it { errors.must_equal ["is not 10 characters"] }
			end

			context 'when value is too long' do
				let(:value) { 'this title is wayyyy to long' }
				it { errors.must_equal ["is not 10 characters"] }
			end

			context 'when value is nil' do
				let(:value) { nil }
				it { errors.must_equal ["is not 10 characters"] }
			end
		end

		describe 'format' do
			let(:options) {{:format => /^\d+$/}}

			context 'when value matches pattern' do
				let(:value) { 123 }
				it { errors.must_be_nil }
			end

			context 'when value does not match' do
				let(:value) { 'abc' }
				it { errors.must_equal ["is not valid"] }
			end

			context 'when value is nil' do
				let(:value) { nil }
				it { errors.must_equal ["is not valid"] }
			end
		end

		describe 'greater_than' do
			let(:options) {{:greater_than => 10}}

			context 'when value is greater than option' do
				let(:value) { 11 }
				it { errors.must_be_nil }
			end

			context 'when float is greater than option' do
				let(:value) { 11.123 }
				it { errors.must_be_nil }
			end

			context 'when value is equal to option' do
				let(:value) { 10 }
				it { errors.must_equal ["must be greater than 10"] }
			end

			context 'when value is less than option' do
				let(:value) { 9 }
				it { errors.must_equal ["must be greater than 10"] }
			end

			context 'when value is string' do
				let(:value) { 'abc' }
				it { errors.must_equal ["must be greater than 10"] }
			end
		end

		describe 'greater_than_or_equal_to' do
			let(:options) {{:greater_than_or_equal_to => 10}}

			context 'when value is greater than option' do
				let(:value) { 11 }
				it { errors.must_be_nil }
			end

			context 'when float value is greater than option' do
				let(:value) { 11.123 }
				it { errors.must_be_nil }
			end

			context 'when value is equal to option' do
				let(:value) { 10 }
				it { errors.must_be_nil }
			end

			context 'when value is less than option' do
				let(:value) { 9 }
				it { errors.must_equal ["must be greater than or equal to 10"] }
			end

			context 'when value is a string' do
				let(:value) { 'abc' }
				it { errors.must_equal ["must be greater than or equal to 10"] }
			end
		end

		describe 'less_than' do
			let(:options) {{:less_than => 10}}

			context 'when value is less than option' do
				let(:value) { 9 }
				it { errors.must_be_nil }
			end

			context 'when float value is less than option' do
				let(:value) { 8.123 }
				it { errors.must_be_nil }
			end

			context 'when value is equal to option' do
				let(:value) { 10 }
				it { errors.must_equal ["must be less than 10"] }
			end

			context 'when value is greater than option' do
				let(:value) { 11 }
				it { errors.must_equal ["must be less than 10"] }
			end

			context 'when value is a string' do
				let(:value) { 'abc' }
				it { errors.must_equal ["must be less than 10"] }
			end
		end

		describe 'less_than_or_equal_to' do
			let(:options) {{:less_than_or_equal_to => 10}}

			context 'when value is less than option' do
				let(:value) { 9 }
				it { errors.must_be_nil }
			end

			context 'when float value is less than option' do
				let(:value) { 8.123 }
				it { errors.must_be_nil }
			end

			context 'when value is equal to option' do
				let(:value) { 10 }
				it { errors.must_be_nil }
			end

			context 'when value is greater than option' do
				let(:value) { 11 }
				it { errors.must_equal ["must be less than or equal to 10"] }
			end

			context 'when value is a string' do
				let(:value) { 'abc' }
				it { errors.must_equal ["must be less than or equal to 10"] }
			end
		end

		describe 'inclusion' do
			context 'when set is array' do
				let(:options) {{:inclusion => %w(cat dog bird rabbit)}}

				context 'when value is in set' do
					let(:value) { 'cat' }
					it { errors.must_be_nil }
				end

				context 'when value is not in set' do
					let(:value) { 'goat' }
					it { errors.must_equal ["is not in set: [\"cat\", \"dog\", \"bird\", \"rabbit\"]"]}
				end
			end

			context 'when set is range' do
				let(:options) {{:inclusion => 10..20}}

				context 'when value is in set' do
					let(:value) { 11 }
					it { errors.must_be_nil }
				end

				context 'when value is not in set' do
					let(:value) { 5 }
					it { errors.must_equal ["is not in set: 10..20"] }
				end
			end
		end

		describe 'integer' do
			let(:options) {{:integer => true}}

			context 'when value is integer' do
				let(:value) { 123 }
				it { errors.must_be_nil }
			end

			context 'when value is float' do
				let(:value) { 123.4 }
				it { errors.must_equal ["is not a number"]}
			end

			context 'when value is string' do
				let(:value) { 'abc' }
				it { errors.must_equal ["is not a number"]}
			end

			context 'when value is nil' do
				let(:value) { nil }
				it { errors.must_equal ["is not a number"]}
			end

			context 'when value is everything else' do
				let(:value) { ['array'] }
				it { errors.must_equal ["is not a number"]}
			end
		end

		describe 'length_range' do
			context 'when range is array' do
				let(:options) {{:length_range => [5, 8, 15]}}

				context 'when value length is in array' do
					let(:value) { 'abcde' }
					it { errors.must_be_nil }
				end

				context 'when value length is not in array' do
					let(:value) { 'abc' }
					it { errors.must_equal ["is too short or too long"] }
				end

				context 'when value length is nil' do
					let(:value) { nil }
					it { errors.must_equal ["is too short or too long"] }
				end
			end

			context 'when range is range' do
				let(:options) {{:length_range => 5..10}}

				context 'when value length is in range' do
					let(:value) { 'abcdef' }
					it { errors.must_be_nil }
				end

				context 'when value length is not in range' do
					let(:value) { 'abc' }
					it { errors.must_equal ["is too short or too long"] }
				end

				context 'when value length is nil' do
					let(:value) { nil }
					it { errors.must_equal ["is too short or too long"] }
				end	
			end
		end

		describe 'max_length' do
			let(:options) {{:max_length => 10}}

			context 'when value length is less than max' do
				let(:value) { 'abc' }
				it { errors.must_be_nil }
			end

			context 'when value is too long' do
				let(:value) { 'abcdefghijklmnop' }
				it { errors.must_equal ["is longer than 10 characters"] }
			end

			context 'when value is nil' do
				let(:value) { nil }
				it { errors.must_equal ["is longer than 10 characters"] }
			end
		end

		describe 'min_length' do
			let(:options) {{:min_length => 5}}

			context 'when value length is greater than min' do
				let(:value) { 'abcdefg' }
				it { errors.must_be_nil }
			end

			context 'when value is too short' do
				let(:value) { 'abcd' }
				it { errors.must_equal ["is shorter than 5 characters"] }
			end

			context 'when value is nil' do
				let(:value) { nil }
				it { errors.must_equal ["is shorter than 5 characters"] }
			end
		end

		describe 'not_null' do
			let(:options) {{:not_null => 5}}

			context 'when value is not null' do
				let(:value) { 123 }
				it { errors.must_be_nil }
			end

			context 'when value is nil' do
				let(:value) { nil }
				it { errors.must_equal ["is not present"]}
			end
		end

		describe 'numeric' do
			let(:options) {{:numeric => true}}

			context 'when value is integer' do
				let(:value) { 123 }
				it { errors.must_be_nil }
			end

			context 'when value is float' do
				let(:value) { 123.4 }
				it { errors.must_be_nil }
			end

			context 'when value is string' do
				let(:value) { 'abc' }
				it { errors.must_equal ["is not a number"]}
			end

			context 'when value is nil' do
				let(:value) { nil }
				it { errors.must_equal ["is not a number"]}
			end

			context 'when value is everything else' do
				let(:value) { ['array'] }
				it { errors.must_equal ["is not a number"]}
			end
		end

		describe 'presence' do
			let(:options) {{:presence => true}}

			context 'when value is not null' do
				let(:value) { 123 }
				it { errors.must_be_nil }
			end

			context 'when value is nil' do
				let(:value) { nil }
				it { errors.must_equal ["is not present"]}
			end

			context 'when value is empty string' do
				let(:value) { '' }
				it { errors.must_equal ["is not present"]}
			end

			context 'when value is string of whitespace' do
				let(:value) { '    ' }
				it { errors.must_equal ["is not present"]}
			end

			context 'when value is empty array' do
				let(:value) { [] }
				it { errors.must_equal ["is not present"]}	
			end

			context 'when value is empty hash' do
				let(:value) {{}}
				it { errors.must_equal ["is not present"]}	
			end
		end
	end

	describe 'conditions' do
		describe 'with_options' do
			let(:conditions) {{:if => true}}
			let(:validator_class) do
				klass = Class.new{
					include Veto.validator

					def create_errors
						errors.add(:base, "error")
					end
				}
				klass.with_options conditions do
					validate :create_errors
				end
				klass
			end	

			context 'when conditions pass' do
				let(:conditions) {{:if => true}}

				it 'performs validations within block' do
					validator.valid?.must_equal false
					validator.errors.full_messages.must_equal ['base error']
				end
			end

			context 'when conditions fail' do
				let(:conditions) {{:if => false}}

				it 'does not perform validations within block' do
					validator.valid?
					validator.errors.must_be_empty
				end
			end
		end	

		describe 'validates' do
			let(:entity){ stub(:title => nil, :name => 'John') }
			let(:options) {{}}
			let(:validator_class) do
				klass = Class.new{
					include Veto.validator
				}

				klass.validates :title, options
				klass
			end	

			context 'when outer conditions pass' do
				context 'when inner conditions pass' do
					let(:options) {{:not_null => {:with => true, :if => true}, :exact_length => {:with => 4, :if => true}, :if => true}}

					it 'performs validation' do
						validator.valid?.must_equal false
						validator.errors.full_messages.must_equal ["title is not present", "title is not 4 characters"]
					end				
				end

				context 'when inner conditions fail' do
					let(:options) {{:not_null => {:with => true, :if => false}, :exact_length => {:with => 4, :if => true}, :if => true}}

					it 'skips individual validator' do
						validator.valid?.must_equal false
						validator.errors.full_messages.must_equal ["title is not 4 characters"]
					end
				end
			end

			context 'when outer conditions fail' do
				let(:options) {{:not_null => {:with => true, :if => true}, :exact_length => {:with => 4, :if => true}, :if => false}}

				it 'skips validates block' do
					validator.valid?.must_equal true
				end
			end
		end
	end

	describe 'custom attribute validator class' do
		let(:entity){ stub(:email_address => 'blah') }
		let(:validator_class) do
			klass = Class.new{
				include Veto.validator

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

	describe 'validator descendents/inheritence' do
		let(:validator_class) do
			Class.new{
				include Veto.validator

				validate :create_superclass_error

				def create_superclass_error
					errors.add(:base, "superclass error")
				end
			}
		end

		context 'when validator is subclassed' do
			let(:validator_subclass) do
				Class.new(validator_class){

					validate :create_subclass_error

					def create_subclass_error
						errors.add(:base, "subclass error")
					end
				}
			end	

			it 'inherits superclass validation rules' do
				validator = validator_subclass.new(entity)

				validator.valid?
				validator.errors.must_equal({:base=>["superclass error", "subclass error"]})
			end
		end
	end
end