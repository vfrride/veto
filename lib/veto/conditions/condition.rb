require 'veto/conditions/string_condition'
require 'veto/conditions/symbol_condition'
require 'veto/conditions/proc_condition'
require 'veto/conditions/misc_condition'

module Veto
	class Condition
		def self.truthy? context, entity, condition
			[StringCondition, SymbolCondition, ProcCondition, MiscCondition].each do |klass|
				if klass.match?(condition)
					return klass.truthy?(context, entity, condition)
				end
			end
		end
	end
end