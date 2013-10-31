module Veto
	class MiscCondition
		def self.match? condition
			true
		end

		def self.truthy? context, entity, condition
			!!condition
		end		
	end
end