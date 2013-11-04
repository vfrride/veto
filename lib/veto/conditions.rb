module Veto
	class Conditions
		def self.truthy? condition, context, entity
			case condition
			when String
				!!entity.instance_eval(condition)
			when Symbol
				!!context.send(condition)
			when Proc
				!!condition.call(entity)
			else
				!!condition
			end
		end

		def self.truthy_conditions? conditions, context, entity
			return true if !conditions.key?(:if) && !conditions.key?(:unless)

			[*conditions[:if]].each do |condition| 
				return false unless truthy?(condition, context, entity) 
			end

			[*conditions[:unless]].each do |condition| 
				return false if truthy?(condition, context, entity) 
			end

			true
		end

		attr_reader :conditions

		def initialize conditions
			@conditions = conditions
		end

		def call *args
			truthy? *args
		end

		def truthy? context, entity
			self.class.truthy_conditions?(conditions, context, entity)
		end
	end
end