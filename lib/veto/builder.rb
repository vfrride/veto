require 'veto/validates_options'
require 'veto/validator_factory'
require 'veto/blocks/conditional_list_block'
require 'veto/conditional_evaluator'

module Veto
	class Builder
		attr_reader :context_block

		def initialize context_block, &block
			@context_block = context_block
			instance_eval(&block) if block_given?
		end

		def with_options conditions={}, &block
			list_block = new_conditional_list(conditions)
			context_block.add list_block
			::Veto::Builder.new(list_block, &block)
		end

		def validates attribute, options={}
			vsopts = ::Veto::ValidatesOptions.new(attribute, options)
			outer_list = new_conditional_list(vsopts.conditions)
			vsopts.each_validator_options do |vopts|
				inner_list = new_conditional_list(vopts.conditions)
				validator = ::Veto::ValidatorFactory.new_validator(vopts.type, vopts.attribute, vopts.options)
				inner_list.add validator
				outer_list.add inner_list
			end
			context_block.add outer_list
		end

		def validate method_names, conditions={}
			list = new_conditional_list(conditions)
			[*method_names].each do |method_name|
				list.add ::Veto::ContextMethodValidator.new(method_name)
			end
			context_block.add list
		end

		private

		def new_conditional_list conditions={}
			::Veto::ConditionalListBlock.new(::Veto::ConditionalEvaluator.new(conditions))
		end
	end
end