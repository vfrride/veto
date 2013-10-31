module Veto
	class ConditionalEvaluator
		def self.truthy? condition, context, entity
			result = case condition
			when String
				entity.instance_eval(condition)
			when Symbol
				context.send(condition)
			when Proc
				condition.call(entity)
			else
				condition
			end
			!!result
		end

		def self.truthy_conditionals? conditionals, context, entity
			return true if !conditionals.key?(:if) && !conditionals.key?(:unless)

			[*conditionals[:if]].each do |condition| 
				return false unless truthy?(condition, context, entity) 
			end

			[*conditionals[:unless]].each do |condition| 
				return false if truthy?(condition, context, entity) 
			end

			true
		end

		attr_reader :conditionals

		def initialize conditionals
			@conditionals = conditionals
		end

		def call context, entity
			self.class.truthy_conditionals?(conditionals, context, entity)
		end
	end
end