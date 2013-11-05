require 'veto/conditions'
require 'veto/attribute_validator_factory'
require 'veto/validators/custom_method_validator'

module Veto			
	class Builder
		attr_reader :context, :conditions_context

		def initialize context, conditions_context={}, &block
			@context = context
			@conditions_context = conditions_context
			instance_eval(&block) if block_given?
		end

		def with_options conditions={}, &block
			mc = ::Veto::Conditions.merge(conditions_context, conditions)
			::Veto::Builder.new(context, mc, &block)
		end

		def validates attribute, options={}
			a = attribute
			c = ::Veto::Conditions.select(options)
			mc = ::Veto::Conditions.merge(conditions_context, c)
			o = ::Veto::Conditions.reject(options)
			vs = o.map do |t, vopts|
				vo = case vopts
				when TrueClass
					{}
				when Hash
					vopts
				when Range, Array
					{ :in => vopts }
				else
					{ :with => vopts }
				end

				vc = ::Veto::Conditions.select(vo)
				mvc = ::Veto::Conditions.merge(mc, vc)
				mvo = vo.merge(mvc)
				::Veto::AttributeValidatorFactory.new_validator(t, a, mvo)
			end
			validate_with vs
		end

		def validate *method_names
			if method_names.last.is_a?(Hash)
				c = method_names.last
				mns = method_names[0..-2]
			else
				c = {}
				mns = method_names
			end

			mc = ::Veto::Conditions.merge(conditions_context, c)
			vs = mns.map do |mn|
				::Veto::CustomMethodValidator.new(mn, mc)
			end
			validate_with vs
		end

		def validate_with *args
			context.validate_with *args
		end
	end
end