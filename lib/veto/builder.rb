require 'veto/conditional_validator_list'
require 'veto/validator_config'
require 'veto/validator_factory'

module Veto
	class Builder
		attr_reader :validator_list

		def initialize validator_list, &block
			@validator_list = validator_list
			instance_eval(&block) if block_given?
		end

		def with_options conditions={}, &block
			inner_list = ::Veto::ConditionalValidatorList.new(conditions)
			validator_list.add(inner_list)
			::Veto::Builder.new(inner_list, &block)
		end

		def validates attribute, validations={}
			validations.each do |type, options|
				v_conf = ::Veto::ValidatorConfig.new(type, attribute, options)
				conditional_validator_list = ::Veto::ConditionalValidatorList.new(v_conf.conditions)
				conditional_validator_list.add ::Veto::ValidatorFactory.new_validator(v_conf.type, v_conf.attribute, v_conf.options)
				validator_list.add conditional_validator_list
			end
		end

		# def validate method_or_proc
		# 	validator_list.add ::Veto::BlockValidator.new(method_or_proc)
		# end
	end
end