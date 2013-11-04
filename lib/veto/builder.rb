require 'veto/checker_factory'
require 'veto/conditions'
require 'veto/blocks/conditional_list_block'
require 'veto/validates_options'
require 'veto/checkers/context_method_checker'

module Veto			
	class Builder
		attr_reader :context_list

		def initialize context_list, &block
			@context_list = context_list
			instance_eval(&block) if block_given?
		end

		def with_options conditions={}, &block
			list_block = new_condition_list(conditions)
			context_list.add list_block
			::Veto::Builder.new(list_block, &block)
		end

		def validates attribute, options={}
			vsopts = ::Veto::Validates::ValidatesOptions.new(attribute, options)
			outer_list = new_condition_list(vsopts.conditions)
			vsopts.each_checker_options do |vopts|
				inner_list = new_condition_list(vopts.conditions)
				validator = ::Veto::CheckerFactory.new_checker(vopts.type, vopts.attribute, vopts.options)
				inner_list.add validator
				outer_list.add inner_list
			end
			context_list.add outer_list
		end

		def validate method_names, conditions={}
			list = new_condition_list(conditions)
			[*method_names].each do |method_name|
				validator = ::Veto::ContextMethodChecker.new(method_name)
				list.add validator
			end
			context_list.add list
		end

		private

		def new_condition_list conditions={}
			::Veto::ConditionalListBlock.new(::Veto::Conditions.new(conditions))
		end
	end
end